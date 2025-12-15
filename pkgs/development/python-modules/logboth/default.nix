{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
}:

buildPythonPackage rec {
  pname = "logboth";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "logboth";
    tag = "v${version}";
    hash = "sha256-z62atvFYrRqjcGQbTlWadoG1TPrNl8WwDBclzhqQtPA=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preInstallCheck

    python3 source/tests/tests.py

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "logboth" ];

  meta = {
    description = "Easily write logs to standard output and a file at the same time";
    homepage = "https://gitlab.com/zehkira/logboth";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
