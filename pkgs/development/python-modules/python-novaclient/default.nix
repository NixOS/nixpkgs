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
  version = "18.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a2tq4sEescEI469V6qchGw/JGZk1oimmuj4N5RTBK1A=";
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
