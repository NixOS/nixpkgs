{ fetchurl
, lib
, stdenv
, meson
, ninja
, pkg-config
, gnome
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
, harfbuzz
, makeWrapper
, which
, xvfb-run
, nixosTests
}:

let
  testDeps = [
    gobject-introspection # for Gio and cairo typelibs
    gtk3 atk pango.out gdk-pixbuf harfbuzz
  ];
in stdenv.mkDerivation rec {
  pname = "gjs";
  version = "1.70.1";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-u9wO7HzyX7xTR2n2ofssehjhe4ce/bDKWOmr8IsoAD8=";
  };

  patches = [
    # Hard-code various paths
    ./fix-paths.patch

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    xvfb-run
  ] ++ testDeps;

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dprofiler=disabled"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
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
    ln -s $PWD/installed-tests/js/libgjstesttools/libgjstesttools.so $installedTests/libexec/installed-tests/gjs/libgjstesttools.so
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
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" testDeps}"
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

    updateScript = gnome.updateScript {
      packageName = "gjs";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "JavaScript bindings for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gjs/blob/master/doc/Home.md";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
