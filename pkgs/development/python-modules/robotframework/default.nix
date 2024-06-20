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
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "robotframework";
    rev = "refs/tags/v${version}";
    hash = "sha256-pr7x40ja1DwMPffmXQ2W53g1wuD0p63f+6ATfXhqGvE=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ jsonschema ];

  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = with lib; {
    changelog = "https://github.com/robotframework/robotframework/blob/master/doc/releasenotes/rf-${version}.rst";
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
