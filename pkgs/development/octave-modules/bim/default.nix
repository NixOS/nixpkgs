{ buildOctavePackage
, lib
, fetchFromGitHub
, fpl
, msh
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

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/bim/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Package for solving Diffusion Advection Reaction (DAR) Partial Differential Equations";
  };
}
