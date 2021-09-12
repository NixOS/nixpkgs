{ lib
, buildPythonPackage
, fetchPypi
, cliff
, oslo-i18n
, oslo-utils
, openstacksdk
, pbr
, requests-mock
, simplejson
, stestr
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ianpk32vwdllpbk4zhfifqb5b064cbmia2hm02lcrh2m76z0zi5";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    cliff
    openstacksdk
    oslo-i18n
    oslo-utils
    simplejson
  ];

  checkInputs = [
    requests-mock
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "osc_lib" ];

  meta = with lib; {
    description = "OpenStackClient Library";
    homepage = "https://github.com/openstack/osc-lib";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
