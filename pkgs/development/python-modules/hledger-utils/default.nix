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
  version = "1.13.2";

  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "hledger-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-E++gHvXspPodLW2hEESKjg+R5aV39UJpDP8JYQX9iBw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
