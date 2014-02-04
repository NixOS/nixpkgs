{ stdenv, fetchurl, telepathy_glib, farstream, gst_plugins_base, dbus_glib
, pkgconfig, libxslt, python, gstreamer, gst_python, pygobject }:

stdenv.mkDerivation rec {
  name = "${pname}-0.6.0";
  pname = "telepathy-farstream";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "04v414jij2ba71krk7vh4avsz07sfp5w38dmvjwig5isdygy0905";
  };

  buildInputs = [ gst_plugins_base gst_python pygobject ];

  propagatedBuildInputs = [ dbus_glib telepathy_glib gstreamer farstream ];
  nativeBuildInputs = [ pkgconfig python libxslt];
}
