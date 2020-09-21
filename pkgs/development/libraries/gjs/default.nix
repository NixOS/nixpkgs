{ fetchurl
, fetchpatch
, stdenv
, meson
, ninja
, pkgconfig
, gnome3
, gtk3
, atk
, gobject-introspection
, spidermonkey_78
, pango
, cairo
, readline
, glib
, libxml2
, dbus
, gdk-pixbuf
, makeWrapper
, which
, xvfb_run
, nixosTests
}:

let
  testDeps = [
    gobject-introspection # for Gio and cairo typelibs
    gtk3 atk pango.out gdk-pixbuf
  ];
in stdenv.mkDerivation rec {
  pname = "gjs";
  version = "1.66.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1y5m7as3jwhb3svb4xgk443hyxhijralk5q5s3ywidkd047gj37k";
  };

  outputs = [ "out" "dev" "installedTests" ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    makeWrapper
    which # for locale detection
    libxml2 # for xml-stripblanks
  ];

  buildInputs = [
    gobject-introspection
    cairo
    readline
    spidermonkey_78
    dbus # for dbus-run-session
  ];

  checkInputs = [
    xvfb_run
  ] ++ testDeps;

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dprofiler=disabled"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  patches = [
    # Hard-code various paths
    ./fix-paths.patch

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs build/choose-tests-locale.sh
    substituteInPlace installed-tests/debugger-test.sh --subst-var-by gjsConsole $out/bin/gjs-console
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib $installedTests/libexec/installed-tests/gjs
    ln -s $PWD/libgjs.so.0 $out/lib/libgjs.so.0
    ln -s $PWD/installed-tests/js/libgimarshallingtests.so $installedTests/libexec/installed-tests/gjs/libgimarshallingtests.so
    ln -s $PWD/installed-tests/js/libregress.so $installedTests/libexec/installed-tests/gjs/libregress.so
    ln -s $PWD/installed-tests/js/libwarnlib.so $installedTests/libexec/installed-tests/gjs/libwarnlib.so
  '';

  postInstall = ''
    # TODO: make the glib setup hook handle moving the schemas in other outputs.
    installedTestsSchemaDatadir="$installedTests/share/gsettings-schemas/${pname}-${version}"
    mkdir -p "$installedTestsSchemaDatadir"
    mv "$installedTests/share/glib-2.0" "$installedTestsSchemaDatadir"
  '';

  postFixup = ''
    wrapProgram "$installedTests/libexec/installed-tests/gjs/minijasmine" \
      --prefix XDG_DATA_DIRS : "$installedTestsSchemaDatadir" \
      --prefix GI_TYPELIB_PATH : "${stdenv.lib.makeSearchPath "lib/girepository-1.0" testDeps}"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs
    runHook postCheck
  '';

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.gjs;
    };

    updateScript = gnome3.updateScript {
      packageName = "gjs";
    };
  };

  meta = with stdenv.lib; {
    description = "JavaScript bindings for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gjs/blob/master/doc/Home.md";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
