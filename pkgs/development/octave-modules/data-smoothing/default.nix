{
  buildOctavePackage,
  lib,
  fetchurl,
  optim,
}:

buildOctavePackage rec {
  pname = "data-smoothing";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-ASvXqWgWGe0z2GQ/N4W6mxeoL+urmyQmdP55dGvDG2A=";
  };

  requiredOctavePackages = [
    optim
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/data-smoothing/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Algorithms for smoothing noisy data";
    # Hasn't been updated since 2012, and fails to build with octave >= 10.1.0
    broken = true;
  };
}
