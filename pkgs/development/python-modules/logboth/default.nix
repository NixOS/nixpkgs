{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "logboth";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "logboth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sPt0Xdh2i71riP3L2knXvL25Q08vtnhfzGnDrKqdXtQ=";
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
})
