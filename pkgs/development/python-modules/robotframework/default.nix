{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  python,
}:

buildPythonPackage rec {
  pname = "robotframework";
  version = "7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "robotframework";
    tag = "v${version}";
    hash = "sha256-G+mmSeTLr6h0e2YCJOpbYaRNZ5M6PXWBYXdn9xGitkM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ jsonschema ];

  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = {
    changelog = "https://github.com/robotframework/robotframework/blob/master/doc/releasenotes/rf-${version}.rst";
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
