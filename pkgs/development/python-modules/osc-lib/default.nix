{ lib, buildPythonPackage, fetchPypi
, pbr, cliff, keystoneauth1, openstacksdk, oslo-i18n, oslo-utils, simplejson, stevedore
, stestr, requests-mock }:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ianpk32vwdllpbk4zhfifqb5b064cbmia2hm02lcrh2m76z0zi5";
  };

  propagatedBuildInputs = [
    pbr
    cliff
    keystoneauth1
    openstacksdk
    oslo-i18n
    oslo-utils
    simplejson
    stevedore
  ];

  checkInputs = [ stestr requests-mock ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "osc_lib" ];

  meta = with lib; {
    description = "OpenStackClient Library";
    homepage = "https://docs.openstack.org/osc-lib/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
