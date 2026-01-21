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
  version = "0.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "jenkinsapi";
    tag = version;
    hash = "sha256-1dTcT84cDpP9V4tVrgW2MTYx4jQj0/tZiAuakC+orUQ=";
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

  meta = {
    description = "Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
    maintainers = with lib.maintainers; [
      de11n
      despsyched
      drets
    ];
    license = lib.licenses.mit;
  };
}
