{ stdenv, fetchFromGitLab, pkgconfig, glib, sqlite, gobject-introspection, vala
, autoconf, automake, libtool, gettext, dbus, telepathy-glib
, gtk3, json-glib, librdf_raptor2, dbus-glib
, pythonSupport ? true, python2Packages
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

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [ "--with-session-bus-services-dir=${placeholder ''out''}/share/dbus-1/services" ];

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig gettext gobject-introspection vala python2Packages.python
  ];
  buildInputs = [
    glib sqlite dbus telepathy-glib dbus-glib
    gtk3 json-glib librdf_raptor2 python2Packages.rdflib
  ];

  postPatch = ''
    patchShebangs data/ontology2code
  '';

  enableParallelBuilding = true;

  postFixup = stdenv.lib.optionalString pythonSupport ''
    moveToOutput lib/${python2Packages.python.libPrefix} "$py"
  '';

  meta = with stdenv.lib; {
    description = "A service which logs the users's activities and events";
    homepage = https://zeitgeist.freedesktop.org/;
    maintainers = with maintainers; [ lethalman worldofpeace ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
