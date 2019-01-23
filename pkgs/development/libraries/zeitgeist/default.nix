{ stdenv, fetchFromGitLab, pkgconfig, glib, sqlite, gobject-introspection, vala
, autoconf, automake, libtool, gettext, dbus, telepathy-glib
, gtk3, json-glib, librdf_raptor2, dbus-glib
, pythonSupport ? true, python2Packages
}:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "zeitgeist-${version}";

  outputs = [ "out" "lib" "dev" "man" ] ++ stdenv.lib.optional pythonSupport "py";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "zeitgeist";
    repo = "zeitgeist";
    rev = "v${version}";
    sha256 = "1lgqcqr5h9ba751b7ajp7h2w1bb5qza2w3k1f95j3ab15p7q0q44";
  };

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [ "--with-session-bus-services-dir=$(out)/share/dbus-1/services" ];

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
    homepage = http://zeitgeist.freedesktop.org/;
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
