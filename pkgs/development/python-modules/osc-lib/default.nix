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
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6b530e3e50646840a6a5ef134e00f285cc4a04232c163f28585226ed40cc968";
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
