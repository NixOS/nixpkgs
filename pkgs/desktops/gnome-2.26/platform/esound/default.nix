{stdenv, fetchurl, pkgconfig, alsaLib, audiofile}:

stdenv.mkDerivation {
  name = "esound-0.2.41";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/esound-0.2.41.tar.bz2;
    sha256 = "5eb5dd29a64b3462a29a5b20652aba7aa926742cef43577bf0796b787ca34911";
  };
  buildInputs = [ pkgconfig alsaLib audiofile ];
}
