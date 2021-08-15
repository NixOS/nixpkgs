{ lib, buildPythonPackage, fetchPypi
, pbr, iso8601, requests, six, stevedore, os-service-types, requests-kerberos
, stestr, requests-mock, oslo-config, oslo-utils, lxml, hacking, betamax, oauthlib }:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r4ach6adh7z1kq9k378aii9mgn1kmg6iicvclqlyhnilqq58q4k";
  };

  propagatedBuildInputs = [
    pbr
    iso8601
    requests
    six
    stevedore
    os-service-types
    requests-kerberos
    lxml
    oauthlib
    betamax
  ];

  checkInputs = [ stestr requests-mock oslo-config oslo-utils hacking ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "keystoneauth1" ];

  meta = with lib; {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://docs.openstack.org/keystoneauth/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
