{ stdenv, fetchurl, pkgconfig, glib, sqlite, gnome3, vala
, intltool, libtool, python, dbus_libs, telepathy_glib
, gtk3, json_glib, librdf_raptor2, pythonPackages, dbus_glib }:

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

  buildInputs = [ pkgconfig glib sqlite gnome3.gnome_common intltool
                  libtool python dbus_libs telepathy_glib vala dbus_glib
                  gtk3 json_glib librdf_raptor2 pythonPackages.rdflib ];

  prePatch = "patchShebangs .";

  patches = [ ./dbus_glib.patch ];

  patchFlags = [ "-p0" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A service which logs the users's activities and events";
    homepage = https://launchpad.net/zeitgeist;
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
