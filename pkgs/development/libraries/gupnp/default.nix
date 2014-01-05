{ stdenv, fetchurl, pkgconfig, glib, libxml2, gssdp, libsoup, libuuid }:
 
stdenv.mkDerivation {
  name = "gupnp-0.18.4";

  src = fetchurl {
    url = mirror://gnome/sources/gupnp/0.18/gupnp-0.18.4.tar.xz;
    sha256 = "18bqmy8r44fnga9wz9inlq6k2s0292bnnql0c0n2j4mj25bpshvb";
  };

  propagatedBuildInputs = [ libxml2 libsoup gssdp ];
  buildInputs = [ glib libuuid ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.gupnp.org/;
  };
}
