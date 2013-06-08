{ stdenv, fetchurl, telepathy_glib, farstream, gst_plugins_base, dbus_glib
, pkgconfig, libxslt, python, gstreamer, gst_python, pygobject }:

stdenv.mkDerivation rec {
  name = "${pname}-0.4.0";
  pname = "telepathy-farstream";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "13mllgfx4b1hh1vpzq8lk5qfr3ivkkkmwbxgi6d47avgk746kznd";
  };

  buildInputs = [ gst_plugins_base gst_python pygobject ];

  propagatedBuildInputs = [ dbus_glib telepathy_glib gstreamer farstream ];
  nativeBuildInputs = [ pkgconfig python libxslt];
}
