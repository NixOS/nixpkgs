{stdenv, fetchurl, pkgconfig, alsaLib, audiofile}:

stdenv.mkDerivation {
  name = "esound-0.2.41";
  src = fetchurl {
    url = mirror://gnome/sources/esound/0.2/esound-0.2.41.tar.bz2;
    sha256 = "04a9ldy7hsvry1xmfhzg5is2dabsp8m6a82vkai64d2blqlxvday";
  };
  buildInputs = [ pkgconfig alsaLib audiofile ];
}
