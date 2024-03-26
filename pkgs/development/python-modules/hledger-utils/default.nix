{ lib
, buildPythonPackage
, fetchFromGitLab
, setuptools
, setuptools-scm
, unittestCheckHook
, hledger
, perl
, rich
, pandas
, scipy
, psutil
, matplotlib
, drawilleplot
, asteval
}:

buildPythonPackage rec {
  pname = "hledger-utils";
  version = "1.14.0";

  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "hledger-utils";
    rev = "refs/tags/v${version}";
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

  checkInputs = [
    unittestCheckHook
  ];

  nativeCheckInputs = [
    hledger
    perl
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Utilities extending hledger";
    homepage = "https://gitlab.com/nobodyinperson/hledger-utils";
    license = with licenses; [cc0 cc-by-40 gpl3];
    maintainers = with maintainers; [ nobbz ];
    platforms = platforms.all;
  };
}
