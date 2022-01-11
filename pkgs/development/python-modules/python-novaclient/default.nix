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
, requests-mock
, stestr
, testscenarios
}:

buildPythonPackage rec {
  pname = "python-novaclient";
  version = "17.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yRDCCFMQ2mNfs0NYXxBwcS/w+cs8j3nUTKPWMsTyMPU=";
  };

  propagatedBuildInputs = [
    iso8601
    keystoneauth1
    oslo-i18n
    oslo-serialization
    pbr
    prettytable
  ];

  checkInputs = [
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
