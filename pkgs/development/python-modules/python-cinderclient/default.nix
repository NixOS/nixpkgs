{ lib, buildPythonPackage, fetchPypi
, pbr, prettytable, keystoneauth1, simplejson, oslo-i18n, oslo-utils, requests, stevedore
, stestr, requests-mock, ddt, oslo-serialization }:

buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05pizhgkvpr4grcybzpih8fgrwdady22c7frazvp7av441b8rvac";
  };

  propagatedBuildInputs = [
    pbr
    prettytable
    keystoneauth1
    simplejson
    oslo-i18n
    oslo-utils
    requests
    stevedore
  ];

  checkInputs = [ stestr requests-mock ddt oslo-serialization ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "cinderclient" ];

  meta = with lib; {
    description = "OpenStack Block Storage API Client Library";
    homepage = "https://docs.openstack.org/python-cinderclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
