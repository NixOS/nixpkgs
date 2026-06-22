{
  buildOctavePackage,
  lib,
  fetchurl,
  struct,
  statistics,
  lapack,
  blas,
}:

buildOctavePackage rec {
  pname = "optim";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Wfs3caLSojE0R1MsWaLgAKanu3pnfz74GD+6qrVJOhQ=";
  };

  buildInputs = [
    lapack
    blas
  ];

  requiredOctavePackages = [
    struct
    statistics
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/optim/";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    # Modified BSD code seems removed
    maintainers = with lib.maintainers; [
      ravenjoad
      lnk3
    ];
    description = "Non-linear optimization toolkit";
  };
}
