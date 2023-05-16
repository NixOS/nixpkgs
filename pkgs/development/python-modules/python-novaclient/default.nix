{ lib
, buildPythonPackage
, fetchPypi
, ddt
, iso8601
, keystoneauth1
, openssl
, oslo-i18n
, oslo-serialization
, pbr
, prettytable
, pythonOlder
, requests-mock
, stestr
, testscenarios
}:

buildPythonPackage rec {
  pname = "python-novaclient";
<<<<<<< HEAD
  version = "18.4.0";
=======
  version = "18.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-a2tq4sEescEI469V6qchGw/JGZk1oimmuj4N5RTBK1A=";
=======
    hash = "sha256-UPdYfHorJSj3NQWBf5Q3rFwdBNV26b4mTS3u/9t0WnY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    iso8601
    keystoneauth1
    oslo-i18n
    oslo-serialization
    pbr
    prettytable
  ];

  nativeCheckInputs = [
    ddt
    openssl
    requests-mock
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run -e <(echo "
    novaclient.tests.unit.test_shell.ShellTest.test_osprofiler
    novaclient.tests.unit.test_shell.ShellTestKeystoneV3.test_osprofiler
    ")
  '';

  pythonImportsCheck = [ "novaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Compute API";
    homepage = "https://github.com/openstack/python-novaclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
