{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  fpl,
  msh,
}:

buildOctavePackage rec {
  pname = "bim";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "carlodefalco";
    repo = "bim";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-HNN6wFDBFsTj4gUQetODsNDbZK4sAFpUL43Q4+kKI6k=";
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
