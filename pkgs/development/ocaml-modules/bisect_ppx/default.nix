{ lib, fetchFromGitHub, fetchpatch, buildDunePackage, cmdliner, ppxlib }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    hash = "sha256-Uc5ZYL6tORcCCvCe9UmOnBF68FqWpQ4bc48fTQwnfis=";
  };

  patches = [
    # Ppxlib >= 0.28.0 compatibility
    # remove when a new version is released
    (fetchpatch {
      name = "${pname}-${version}-ppxlib-0.28-compatibility.patch";
      url = "https://github.com/anmonteiro/bisect_ppx/commit/cc442a08e3a2e0e18deb48f3a696076ac0986728.patch";
      sha256 = "sha256-pPHhmtd81eWhQd4X0gfZNPYT75+EkurwivP7acfJbNc=";
    })
  ];

  minimalOCamlVersion = "4.11";
  duneVersion = "3";

  buildInputs = [
    cmdliner
    ppxlib
  ];

  meta = with lib; {
    description = "Bisect_ppx is a code coverage tool for OCaml and Reason. It helps you test thoroughly by showing what's not tested.";
    homepage = "https://github.com/aantron/bisect_ppx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "bisect-ppx-report";
  };
}
