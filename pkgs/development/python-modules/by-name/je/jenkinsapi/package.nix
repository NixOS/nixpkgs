{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mock,
  pbr,
  pytest-mock,
  pytestCheckHook,
  pytz,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.15";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "jenkinsapi";
    tag = version;
    hash = "sha256-r6GOi/0ALJDy6R6cd/bECk+HVe/AyKZYG96sr9y9o/4=";
  };

  nativeBuildInputs = [
    flit-core
    pbr
  ];

  propagatedBuildInputs = [
    pytz
    requests
    setuptools
    six
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  # don't run tests that try to spin up jenkins
  disabledTests = [ "systests" ];

  pythonImportsCheck = [
    "jenkinsapi"
    "jenkinsapi.utils"
    "jenkinsapi.utils.jenkins_launcher"
  ];

  meta = with lib; {
    description = "Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
    maintainers = with maintainers; [ drets ];
    teams = [ teams.deshaw ];
    license = licenses.mit;
  };
}
