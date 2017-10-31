{ stdenv, fetchurl, pkgconfig, glib, sqlite, gnome3, vala_0_23
, intltool, libtool, dbus_libs, telepathy_glib
, gtk3, json_glib, librdf_raptor2, dbus_glib
, pythonSupport ? true, python2Packages
}:

stdenv.mkDerivation rec {
  version = "0.9.15";
  name = "zeitgeist-${version}";

  src = fetchurl {
    url = "https://github.com/seiflotfy/zeitgeist/archive/v${version}.tar.gz";
    sha256 = "07pnc7kmjpd0ncm32z6s3ny5p4zl52v9lld0n0f8sp6cw87k12p0";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-session-bus-services-dir=$(out)/share/dbus-1/services" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib sqlite gnome3.gnome_common intltool
                  libtool dbus_libs telepathy_glib vala_0_23 dbus_glib
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
