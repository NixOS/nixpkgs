{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ttf-bitstream-vera-1.10";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/ttf-bitstream-vera-1.10.tar.bz2;
    sha256 = "1p3qs51x5327gnk71yq8cvmxc6wgx79sqxfvxcv80cdvgggjfnyv";
  };
  buildPhase = "true";
  installPhase = "
    fontDir=$out/share/fonts/truetype
    mkdir -p $fontDir
    cp *.ttf $fontDir
  ";
}
