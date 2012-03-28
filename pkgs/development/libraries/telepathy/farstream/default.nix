{ stdenv, fetchurl, telepathy_glib, farstream, gst_plugins_base, dbus_glib
, pkgconfig, libxslt, python, gstreamer, gst_python, pygobject }:

stdenv.mkDerivation rec {
  name = "${pname}-0.2.2";
  pname = "telepathy-farstream";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "0gdcf50dz1hf22az5jqal2jlzbb1nl2cim579kv3q87b8lq9aplv";
  };

  buildInputs = [ gst_plugins_base gst_python pygobject ];

  propagatedBuildInputs = [ dbus_glib farstream telepathy_glib gstreamer ];
  buildNativeInputs = [ pkgconfig python libxslt];
}
