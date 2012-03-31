{ stdenv, fetchurl, telepathy_glib, farstream, gst_plugins_base, dbus_glib
, pkgconfig, libxslt, python, gstreamer, gst_python, pygobject }:

stdenv.mkDerivation rec {
  name = "${pname}-0.2.3";
  pname = "telepathy-farstream";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1a163gk9y3ckabm4a43lxc5a7j2s42hykbwr6r7b5mlfyqq8myx1";
  };

  buildInputs = [ gst_plugins_base gst_python pygobject ];

  propagatedBuildInputs = [ dbus_glib farstream telepathy_glib gstreamer ];
  buildNativeInputs = [ pkgconfig python libxslt];
}
