{ stdenv, fetchgit, pkgconfig, glib, sqlite, gnome3, vala_0_38
, intltool, libtool, dbus_libs, telepathy_glib
, gtk3, json_glib, librdf_raptor2, dbus_glib
, pythonSupport ? true, python2Packages
}:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "zeitgeist-${version}";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/git/zeitgeist/zeitgeist";
    rev = "v${version}";
    sha256 = "0vw6m0azycqabbz8f0fd8xsh5kf6j3ig4wpqlhw6sklvf44ii5b8";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-session-bus-services-dir=$(out)/share/dbus-1/services" ];

  nativeBuildInputs = [ pkgconfig gnome3.gnome_common intltool libtool vala_0_38 ];
  buildInputs = [ glib sqlite dbus_libs telepathy_glib dbus_glib
                  gtk3 json_glib librdf_raptor2 python2Packages.rdflib ];

  prePatch = "patchShebangs .";

  patches = [ ./dbus_glib.patch ];

  patchFlags = [ "-p0" ];

  enableParallelBuilding = true;

  postFixup = ''
  '' + stdenv.lib.optionalString pythonSupport ''
    moveToOutput lib/${python2Packages.python.libPrefix} "$py"
  '';

  outputs = [ "out" ] ++ stdenv.lib.optional pythonSupport "py";

  meta = with stdenv.lib; {
    description = "A service which logs the users's activities and events";
    homepage = https://launchpad.net/zeitgeist;
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
