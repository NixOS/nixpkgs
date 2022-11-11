{ stdenv
, fetchurl
, nixosTests
, fixDarwinDylibNames
, meson
, ninja
, pkg-config
, gettext
, python3
, docutils
, gi-docgen
, glib
, libtiff
, libjpeg
, libpng
, gnome
, gobject-introspection
, buildPackages
, doCheck ? false
, makeWrapper
, lib
}:

stdenv.mkDerivation rec {
  pname = "gdk-pixbuf";
  version = "2.42.10";

  outputs = [ "out" "dev" "man" "devdoc" ]
    ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) "installedTests";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "7ptsddE7oJaQei48aye2G80X9cfr6rWltDnS8uOf5Es=";
  };

  patches = [
    # Move installed tests to a separate output
    ./installed-tests-path.patch
  ];

  # gdk-pixbuf-thumbnailer is not wrapped therefore strictDeps will work
  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3
    makeWrapper
    glib
    gi-docgen
    gobject-introspection

    # for man pages
    docutils
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
    glib
    libtiff
    libjpeg
    libpng
  ];

  mesonFlags = [
    "-Dgio_sniffing=false"
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x build-aux/* # patchShebangs only applies to executables
    patchShebangs build-aux

    substituteInPlace tests/meson.build --subst-var-by installedtestsprefix "$installedTests"

    # Run-time dependency gi-docgen found: NO (tried pkgconfig and cmake)
    # it should be a build-time dep for build
    # TODO: send upstream
    substituteInPlace docs/meson.build \
      --replace "dependency('gi-docgen'," "dependency('gi-docgen', native:true," \
      --replace "'gi-docgen', req" "'gi-docgen', native:true, req"
  '';

  postInstall =
    ''
      # All except one utility seem to be only useful during building.
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

    '' + lib.optionalString stdenv.isDarwin ''
      # meson erroneously installs loaders with .dylib extension on Darwin.
      # Their @rpath has to be replaced before gdk-pixbuf-query-loaders looks at them.
      for f in $out/${passthru.moduleDir}/*.dylib; do
          install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
          mv $f ''${f%.dylib}.so
      done
    '' + ''
      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      ${stdenv.hostPlatform.emulator buildPackages} $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '';

  # The fixDarwinDylibNames hook doesn't patch binaries.
  preFixup = lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* $dev/bin/*; do
        install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
    done
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit doCheck;

  setupHook = ./setup-hook.sh;

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };

    tests = {
      installedTests = nixosTests.installed-tests.gdk-pixbuf;
    };

    # gdk_pixbuf_moduledir variable from gdk-pixbuf-2.0.pc
    moduleDir = "lib/gdk-pixbuf-2.0/2.10.0/loaders";
  };

  meta = with lib; {
    description = "A library for image loading and manipulation";
    homepage = "https://gitlab.gnome.org/GNOME/gdk-pixbuf";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    mainProgram = "gdk-pixbuf-thumbnailer";
    platforms = platforms.unix;
  };
}
