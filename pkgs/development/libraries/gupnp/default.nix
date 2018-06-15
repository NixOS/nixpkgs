{ stdenv, fetchurl, pkgconfig, glib, gssdp, libsoup, libxml2, libuuid }:
 
stdenv.mkDerivation rec {
  name = "gupnp-${version}";
  majorVersion = "1.0";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${majorVersion}/gupnp-${version}.tar.xz";
    sha256 = "043nqxlj030a3wvd6x4c9z8fjarjjjsl2pjarl0nn70ig6kzswsi";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib gssdp libsoup libxml2 libuuid ];

  postInstall = ''
    ln -sv ${libsoup.dev}/include/libsoup-2*/libsoup $out/include
    ln -sv ${libxml2.dev}/include/*/libxml $out/include
    ln -sv ${gssdp}/include/*/libgssdp $out/include
  '';

  meta = {
    homepage = http://www.gupnp.org/;
    description = "An implementation of the UPnP specification";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
