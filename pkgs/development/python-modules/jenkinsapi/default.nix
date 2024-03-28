{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, mock
, pbr
, pytest-mock
, pytestCheckHook
, pytz
, requests
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JGqYpj5h9UoV0WEFyxVIjFZwc030HobHrw1dnAryQLk=";
  };

  nativeBuildInputs = [
    setuptools # test need pkg_resources
    flit-core
    pbr
  ];

  propagatedBuildInputs = [
    pytz
    requests
    six
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  # don't run tests that try to spin up jenkins
  disabledTests = [ "systests" ];

  pythonImportsCheck = [ "jenkinsapi" ];

  meta = with lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
    maintainers = with maintainers; [ drets ] ++ teams.deshaw.members;
    license = licenses.mit;
  };

}
