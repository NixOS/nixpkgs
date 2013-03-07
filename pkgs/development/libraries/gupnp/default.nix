{ stdenv, fetchurl, pkgconfig, glib, libxml2, gssdp, libsoup, libuuid }:
 
stdenv.mkDerivation {
  name = "gupnp-0.18.1";

  src = fetchurl {
    url = mirror://gnome/sources/gupnp/0.18/gupnp-0.18.1.tar.xz;
    sha256 = "1bn98mw4zicg0a7a2xjr4j93ksnpwkhccii8y8zy08g7x2jg3dhk";
  };

  propagatedBuildInputs = [ libxml2 libsoup gssdp ];
  buildInputs = [ glib libuuid ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.gupnp.org/;
  };
}
