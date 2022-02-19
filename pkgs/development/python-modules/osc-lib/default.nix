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
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2PikUPqyoSlOCu+M3JolWhvMW1jhsvYJjjXm2x4T6dE=";
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
