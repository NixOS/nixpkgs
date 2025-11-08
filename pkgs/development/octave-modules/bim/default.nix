{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  fpl,
  msh,
}:

buildOctavePackage rec {
  pname = "bim";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "carlodefalco";
    repo = "bim";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-nK/VZ+thMuMU5RBiNYpzylOuVxKbcfSyrXZfka5+g4I=";
  };

  requiredOctavePackages = [
    fpl
    msh
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/bim/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Package for solving Diffusion Advection Reaction (DAR) Partial Differential Equations";
  };
}
