{ stdenv, fetchurl, telepathy_glib, farsight2, gstPluginsBase, dbus_glib
, pkgconfig, libxslt, python, gstreamer, gst_python, pygobject }:

stdenv.mkDerivation rec {
  name = "telepathy-farsight-0.0.19";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-farsight/${name}.tar.gz";
    sha256 = "0sajy2w109zc6assqby3cfqr7cckwhfsngkhjczz67grb6rbi29c";
  };

  buildInputs = [ gstPluginsBase gst_python pygobject ];

  propagatedBuildInputs = [ dbus_glib farsight2 telepathy_glib gstreamer ];
  buildNativeInputs = [ pkgconfig python libxslt];
}
