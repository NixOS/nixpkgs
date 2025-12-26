{
  buildOctavePackage,
  lib,
  fetchurl,
  signal,
  hdf5,
}:

buildOctavePackage rec {
  pname = "communications";
  version = "1.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-UXaoV45mdmA7n2cB8J3S+/8Nt7uhokyv2MVBm+FK5lw=";
  };

  buildInputs = [
    hdf5
  ];

  requiredOctavePackages = [
    signal
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/communications/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Digital Communications, Error Correcting Codes (Channel Code), Source Code functions, Modulation and Galois Fields";
  };
}
