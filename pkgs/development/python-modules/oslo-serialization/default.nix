{ lib, buildPythonPackage, fetchPypi
, pbr, msgpack, oslo-utils, pytz
, stestr, oslotest }:

buildPythonPackage rec {
  pname = "oslo-serialization";
  version = "4.1.0";

  src = fetchPypi {
    inherit version;
    pname = "oslo.serialization";
    sha256 = "0yakvsja145y89j3r7njg826ig0rmyrw5mnvf35qav40vya7gk6f";
  };

  propagatedBuildInputs = [
    pbr
    msgpack
    oslo-utils
    pytz
  ];

  checkInputs = [ stestr oslotest ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslo_serialization" ];

  meta = with lib; {
    description = "Oslo Serialization library";
    homepage = "https://docs.openstack.org/oslo.utils/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
