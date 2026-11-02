{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  xmltodict,
  responses,
  python,
}:

buildPythonPackage rec {
  pname = "qnapstats";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colinodell";
    repo = "python-qnapstats";
    tag = version;
    hash = "sha256-UoG0hHZdfXmVZPckyilWQX5YbxS1Xd+ngv09XJEm64o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    xmltodict
  ];

  nativeCheckInputs = [ responses ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test-models.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "qnapstats" ];

  meta = {
    changelog = "https://github.com/colinodell/python-qnapstats/releases/tag/${src.tag}";
    description = "Python API for obtaining QNAP NAS system stats";
    homepage = "https://github.com/colinodell/python-qnapstats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
