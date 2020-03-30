{ fetchurl
, stdenv
, pkgconfig
, gnome3
, gtk3
, atk
, gobject-introspection
, spidermonkey_60
, pango
, cairo
, readline
, glib
, libxml2
, dbus
, gdk-pixbuf
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gjs";
  version = "1.58.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fm1szmhdawvgbf9fh6vvkv1fdvbn888fciyi2wkhx48kz09jvg7";
  };

  outputs = [ "out" "dev" "installedTests" ];

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    libxml2 # for xml-stripblanks
  ];

  buildInputs = [
    gobject-introspection
    cairo
    readline
    spidermonkey_60
    dbus # for dbus-run-session
  ];

  propagatedBuildInputs = [
    glib
  ];

  configureFlags = [
    "--enable-installed-tests"
  ];

  postPatch = ''
    for f in installed-tests/*.test.in; do
      substituteInPlace "$f" --subst-var-by pkglibexecdir "$installedTests/libexec/gjs"
    done
  '';

  postInstall = ''
    moveToOutput "share/installed-tests" "$installedTests"
    moveToOutput "libexec/gjs/installed-tests" "$installedTests"

    wrapProgram "$installedTests/libexec/gjs/installed-tests/minijasmine" \
      --prefix GI_TYPELIB_PATH : "${stdenv.lib.makeSearchPath "lib/girepository-1.0" [ gtk3 atk pango.out gdk-pixbuf ]}:$installedTests/libexec/gjs/installed-tests"
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
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
