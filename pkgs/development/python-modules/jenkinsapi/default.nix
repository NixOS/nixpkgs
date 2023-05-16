<<<<<<< HEAD
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
, six
=======
{ lib, stdenv
, buildPythonPackage
, pythonAtLeast
, fetchPypi
, mock
, pytest
, pytest-mock
, pytz
, requests
, requests-kerberos
, toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.13";
<<<<<<< HEAD
  format = "pyproject";
=======
  format = "setuptools";

  disabled = pythonAtLeast "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JGqYpj5h9UoV0WEFyxVIjFZwc030HobHrw1dnAryQLk=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
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
=======
  propagatedBuildInputs = [ pytz requests ];
  nativeCheckInputs = [ mock pytest pytest-mock requests-kerberos toml ];
  # TODO requests-kerberos is broken on darwin, weeding out the broken tests without
  # access to macOS is not an adventure I am ready to embark on - @rski
  doCheck = !stdenv.isDarwin;
  # don't run tests that try to spin up jenkins, and a few more that are mysteriously broken
  checkPhase = ''
    py.test jenkinsapi_tests \
      -k "not systests and not test_plugins and not test_view"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
<<<<<<< HEAD
    maintainers = with maintainers; [ drets ] ++ teams.deshaw.members;
=======
    maintainers = with maintainers; [ drets ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };

}
