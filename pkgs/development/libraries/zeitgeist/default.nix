{ stdenv
, fetchFromGitLab
, fetchpatch
, pkgconfig
, glib
, sqlite
, gobject-introspection
, vala
, autoconf
, automake
, libtool
, gettext
, dbus
, gtk3
, json-glib
, librdf_raptor2
, pythonSupport ? true
, python2Packages
}:

stdenv.mkDerivation rec {
  pname = "zeitgeist";
  version = "1.0.2";

  outputs = [ "out" "lib" "dev" "man" ] ++ stdenv.lib.optional pythonSupport "py";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0ig3d3j1n0ghaxsgfww6g2hhcdwx8cljwwfmp9jk1nrvkxd6rnmv";
  };

  patches = [
    # Fix build with gettext 0.20
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/zeitgeist/zeitgeist/commit/b5c00e80189fd59a059a95c4e276728a2492cb89.patch";
      sha256 = "1r7f7j3l2p6xlzxajihgx8bzbc2sxcb9spc9pi26rz9bwmngdyq7";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
    gettext
    gobject-introspection
    vala
    python2Packages.python
  ];

  buildInputs = [
    glib
    sqlite
    dbus
    gtk3
    json-glib
    librdf_raptor2
    python2Packages.rdflib
  ];

  configureFlags = [
    "--with-session-bus-services-dir=${placeholder "out"}/share/dbus-1/services"
    "--disable-telepathy"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs data/ontology2code
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = stdenv.lib.optionalString pythonSupport ''
    moveToOutput lib/${python2Packages.python.libPrefix} "$py"
  '';

  meta = with stdenv.lib; {
    description = "A service which logs the users’s activities and events";
    homepage = "https://zeitgeist.freedesktop.org/";
    maintainers = with maintainers; [ lethalman worldofpeace ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
