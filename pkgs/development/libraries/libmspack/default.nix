{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libmspack";
  version = "0.10.1alpha";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/libmspack/${pname}-${version}.tar.gz";
    sha256 = "13janaqsvm7aqc4agjgd4819pbgqv50j88bh5kci1z70wvg65j5s";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = "https://www.cabextract.org.uk/libmspack";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.unix;
  };
}
