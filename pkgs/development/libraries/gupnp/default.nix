{ stdenv, fetchurl, pkgconfig, glib, libxml2, gssdp, libsoup, libuuid }:
 
stdenv.mkDerivation rec {
  name = "gupnp-${version}";
  majorVersion = "0.20";
  version = "${majorVersion}.9";
  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${majorVersion}/gupnp-${version}.tar.xz";
    sha256 = "0vicydn3f72x1rqql7857ans85mg7dfap7n7h8xrfyb9whxhlrb1";
  };

  propagatedBuildInputs = [ libxml2 libsoup gssdp ];
  buildInputs = [ glib libuuid ];

  nativeBuildInputs = [ pkgconfig ];

  postInstall = '' 
    cp -r ${libsoup}/include/libsoup-2.4/libsoup $out/include
    cp -r ${gssdp}/include/gssdp-1.0/libgssdp $out/include
    cp -r ${libxml2}/include/libxml2/libxml $out/include
    '';

  meta = {
    homepage = http://www.gupnp.org/;
    description = "GUPnP is an implementation of the UPnP specification.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
