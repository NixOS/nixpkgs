{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "vermin";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netromdk";
    repo = "vermin";
    rev = "v${version}";
    hash = "sha256-lgxYQ8oNfa0+8BUf3nRv0fcNLP+UATjz733ms3pM6gQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    python runtests.py
    runHook postCheck
  '';

  meta = {
    mainProgram = "vermin";
    homepage = "https://github.com/netromdk/vermin";
    changelog = "https://github.com/netromdk/vermin/releases/tag/v${version}";
    description = "Concurrently detect the minimum Python versions needed to run code";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
}
