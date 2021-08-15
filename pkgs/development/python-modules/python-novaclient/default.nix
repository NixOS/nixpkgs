{ lib, buildPythonPackage, fetchPypi
, pbr, keystoneauth1, iso8601, oslo-i18n, oslo-serialization, oslo-utils, prettytable, stevedore
, stestr, testscenarios, requests-mock, ddt, openssl }:

buildPythonPackage rec {
  pname = "python-novaclient";
  version = "17.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zzfkd6gjr5knzf43fnpzgdjkbabw0a5z5ppq9b6wcxifjdgx83s";
  };

  postPatch = ''
    # Skip 2 broken tests
    substituteInPlace novaclient/tests/unit/test_shell.py --replace "test_osprofiler" "__test_osprofiler"
  '';

  propagatedBuildInputs = [
    pbr
    keystoneauth1
    iso8601
    oslo-i18n
    oslo-serialization
    oslo-utils
    prettytable
    stevedore
  ];

  checkInputs = [ stestr testscenarios requests-mock ddt openssl ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "novaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Compute API";
    homepage = "https://docs.openstack.org/python-novaclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
