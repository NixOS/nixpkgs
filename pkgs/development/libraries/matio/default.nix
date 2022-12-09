{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "matio";
  version = "1.5.22";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${pname}-${version}.tar.gz";
    sha256 = "sha256-gMPR4iLhFXaLV7feZAo30O58t6O9A52z6pQecfxSBMM=";
  };

  meta = with lib; {
    description = "A C library for reading and writing Matlab MAT files";
    homepage = "http://matio.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "matdump";
    platforms = platforms.all;
  };
}
