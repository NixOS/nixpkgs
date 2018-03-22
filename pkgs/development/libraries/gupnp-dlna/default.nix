{ stdenv, fetchurl, pkgconfig,  gobjectIntrospection, gupnp, gst_plugins_base }:

stdenv.mkDerivation rec {
  name = "gupnp-dlna-${version}";
  majorVersion = "0.10";
  version = "${majorVersion}.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-dlna/${majorVersion}/${name}.tar.xz";
    sha256 = "0spzd2saax7w776p5laixdam6d7smyynr9qszhbmq7f14y13cghj";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  buildInputs = [ gupnp gst_plugins_base ];

  meta = {
    homepage = https://wiki.gnome.org/Projects/GUPnP/;
    description = "Library to ease DLNA-related bits for applications using GUPnP";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
