{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  alcotest,
  qcheck,
  qcheck-alcotest,
}:

buildDunePackage rec {
  version = "5.0.1";
  pname = "pratter";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitLab {
    domain = "forge.tedomum.net";
    owner = "koizel";
    repo = "pratter";
    tag = version;
    hash = "sha256-Ib7EplEvOuYcAS9cfzo5994SqCv2eiysLekYfH09IMw=";
  };

  checkInputs = [
    alcotest
    qcheck
    qcheck-alcotest
  ];
  doCheck = true;

  meta = with lib; {
    description = "Extended Pratt parser";
    homepage = "https://github.com/gabrielhdt/pratter";
    license = licenses.bsd3;
    changelog = "https://github.com/gabrielhdt/pratter/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
