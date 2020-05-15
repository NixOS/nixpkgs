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
, spidermonkey_68
, pango
, cairo
, readline
, glib
, libxml2
, dbus
, gdk-pixbuf
, makeWrapper
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
  version = "1.64.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ywrsfmkxaw11z83dnmb9yqkn6k3c1mkxw2mv6arbwad6x6q7zqm";
  };

  outputs = [ "out" "dev" "installedTests" ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    makeWrapper
    libxml2 # for xml-stripblanks
  ];

  buildInputs = [
    gobject-introspection
    cairo
    readline
    spidermonkey_68
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

  # Gio test is failing
  # https://github.com/NixOS/nixpkgs/pull/81626#issuecomment-599325843
  doCheck = false;

  postPatch = ''
    substituteInPlace installed-tests/debugger-test.sh --subst-var-by gjsConsole $out/bin/gjs-console
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib $installedTests/libexec/gjs/installed-tests
    ln -s $PWD/libgjs.so.0 $out/lib/libgjs.so.0
    ln -s $PWD/installed-tests/js/libgimarshallingtests.so $installedTests/libexec/gjs/installed-tests/libgimarshallingtests.so
    ln -s $PWD/installed-tests/js/libregress.so $installedTests/libexec/gjs/installed-tests/libregress.so
    ln -s $PWD/installed-tests/js/libwarnlib.so $installedTests/libexec/gjs/installed-tests/libwarnlib.so
  '';

  postInstall = ''
    wrapProgram "$installedTests/libexec/gjs/installed-tests/minijasmine" \
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
