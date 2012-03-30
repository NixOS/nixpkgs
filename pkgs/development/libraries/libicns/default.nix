{ stdenv, fetchurl, libpng, openjpeg }:

stdenv.mkDerivation {
  name = "libicns-0.8.0";

  src = fetchurl {
    url = mirror://sourceforge/icns/libicns-0.8.0.tar.gz;
    sha256 = "0jh67nm07jr1nfkfjid3jjw7fyw5hvj6a2fqan1bhg6gyr2hswla";
  };

  buildInputs = [ libpng openjpeg ];
}
