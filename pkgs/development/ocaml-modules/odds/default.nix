{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
  cmdliner,
}:
buildDunePackage rec {
  pname = "odds";
  version = "1.2";

  minimalOCamlVersion = "5.0.0";

  src = fetchFromGitHub {
    owner = "raphael-proust";
    repo = pname;
    tag = version;
    hash = "sha256-tPDowkpsJQKCoeuXOb9zPORoudUvkRBZ3OzkH2QE2zg=";
  };

  buildInputs = [
    cmdliner
  ];

  nativeBuildInputs = [
    menhir
  ];

  meta = {
    description = "Dice roller";
    homepage = "https://github.com/raphael-proust/odds";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.Denommus ];
  };
}
