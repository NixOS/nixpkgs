{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  fpl,
  msh,
}:

buildOctavePackage rec {
  pname = "bim";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "carlodefalco";
    repo = "bim";
    rev = "v${version}";
    sha256 = "sha256-hgFb1KFE1KJC8skIaeT/7h/fg1aqRpedGnEPY24zZSI=";
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
