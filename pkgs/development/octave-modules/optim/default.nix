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
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-VUqOGLtxla6GH1BZwU8aVXhEJlwa3bW/vzq5iFUkeH4=";
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
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Non-linear optimization toolkit";
    # Hasn't been updated since 2022, and fails to build with octave >= 10.1.0
    broken = true;
  };
}
