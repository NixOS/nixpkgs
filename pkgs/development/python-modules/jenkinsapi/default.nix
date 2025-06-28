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
  version = "0.3.14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "jenkinsapi";
    tag = version;
    hash = "sha256-s6yamzH+4tobO8gLFVn+5ZZUnmPja675FXQmIjAb/co=";
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
