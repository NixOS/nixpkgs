{
  lib,
  buildPythonPackage,
  fetchPypi,
  ddt,
  iso8601,
  keystoneauth1,
  openssl,
  oslo-i18n,
  oslo-serialization,
  pbr,
  prettytable,
  pythonOlder,
  requests-mock,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-novaclient";
  version = "18.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VzwQqkILCJjTX7FG7di7AFgGv/8BMa4rWjDKIqyJR3s=";
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
    novaclient.tests.unit.test_shell.ParserTest.test_ambiguous_option
    novaclient.tests.unit.test_shell.ParserTest.test_not_really_ambiguous_option
    novaclient.tests.unit.test_shell.ShellTest.test_osprofiler
    novaclient.tests.unit.test_shell.ShellTestKeystoneV3.test_osprofiler
    ")
  '';

  pythonImportsCheck = [ "novaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Compute API";
    mainProgram = "nova";
    homepage = "https://github.com/openstack/python-novaclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
