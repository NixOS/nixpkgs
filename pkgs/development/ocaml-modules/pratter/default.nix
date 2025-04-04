{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  camlp-streams,
  alcotest,
  qcheck,
  qcheck-alcotest,
}:

buildDunePackage rec {
  version = "3.0.0";
  pname = "pratter";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitLab {
    domain = "forge.tedomum.net";
    owner = "koizel";
    repo = "pratter";
    tag = version;
    hash = "sha256-O9loVYPJ9xoYf221vBbclqNNq2AA3ImUFGHxtfK3Jwc=";
  };

  propagatedBuildInputs = [ camlp-streams ];

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
