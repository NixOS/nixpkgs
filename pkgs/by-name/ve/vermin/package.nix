{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "vermin";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netromdk";
    repo = "vermin";
    rev = "v${version}";
    hash = "sha256-UJAIwxCnI8gcEPgLep5sKHxcDtJFB65S7OA043VN5S8=";
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
