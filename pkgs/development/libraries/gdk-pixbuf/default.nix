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
, doCheck ? false
, makeWrapper
, lib
, testers
, buildPackages
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, gobject-introspection
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdk-pixbuf";
  version = "2.42.10";

  outputs = [ "out" "dev" "man" ]
    ++ lib.optional withIntrospection "devdoc"
    ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) "installedTests";

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
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

    # for man pages
    docutils
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ] ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
    libtiff
    libjpeg
    libpng
  ];

  mesonFlags = [
    "-Dgio_sniffing=false"
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonEnable "introspection" withIntrospection)
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
      for f in $out/${finalAttrs.passthru.moduleDir}/*.dylib; do
          install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
          mv $f ''${f%.dylib}.so
      done
    '' + lib.optionalString withIntrospection ''
      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      ${stdenv.hostPlatform.emulator buildPackages} $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '';

  # The fixDarwinDylibNames hook doesn't patch binaries.
  preFixup = lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* $dev/bin/*; do
        install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
    done
  '';

  postFixup = lib.optionalString withIntrospection ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit doCheck;

  setupHook = ./setup-hook.sh;

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
      versionPolicy = "odd-unstable";
    };

    tests = {
      installedTests = nixosTests.installed-tests.gdk-pixbuf;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };

    # gdk_pixbuf_binarydir and gdk_pixbuf_moduledir variables from gdk-pixbuf-2.0.pc
    binaryDir = "lib/gdk-pixbuf-2.0/2.10.0";
    moduleDir = "${finalAttrs.passthru.binaryDir}/loaders";
  };

  meta = with lib; {
    description = "A library for image loading and manipulation";
    homepage = "https://gitlab.gnome.org/GNOME/gdk-pixbuf";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    mainProgram = "gdk-pixbuf-thumbnailer";
    pkgConfigModules = [ "gdk-pixbuf-2.0" ];
    platforms = platforms.unix;
  };
})
