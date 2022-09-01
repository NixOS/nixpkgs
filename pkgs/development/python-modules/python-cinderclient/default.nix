{ lib
, buildPythonPackage
, fetchPypi
, ddt
, keystoneauth1
, oslo-i18n
, oslo-serialization
, oslo-utils
, pbr
, requests
, prettytable
, requests-mock
, simplejson
, stestr
, stevedore
}:

buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "9.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+bMK8ubm5aEmwsgfNRRcWu5wwglV5t1AmRm+TRuHs0M=";
  };

  propagatedBuildInputs = [
    simplejson
    keystoneauth1
    oslo-i18n
    oslo-utils
    pbr
    prettytable
    requests
    stevedore
  ];

  checkInputs = [
    ddt
    oslo-serialization
    requests-mock
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "cinderclient" ];

  meta = with lib; {
    description = "OpenStack Block Storage API Client Library";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
