{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
  hledger,
  perl,
  rich,
  pandas,
  scipy,
  psutil,
  matplotlib,
  drawilleplot,
  asteval,
}:

buildPythonPackage rec {
  pname = "hledger-utils";
  version = "1.14.0";

  pyproject = true;

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "hledger-utils";
    tag = "v${version}";
    hash = "sha256-Qu4nUcAGTACmLhwc7fkLxITOyFnUHv85qMhtViFumVs=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    rich
    pandas
    scipy
    psutil
    matplotlib
    drawilleplot
    asteval
  ];

  checkInputs = [ unittestCheckHook ];

  nativeCheckInputs = [
    hledger
    perl
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = {
    description = "Utilities extending hledger";
    homepage = "https://gitlab.com/nobodyinperson/hledger-utils";
    license = with lib.licenses; [
      cc0
      cc-by-40
      gpl3
    ];
    maintainers = with lib.maintainers; [ nobbz ];
    platforms = lib.platforms.all;
  };
}
