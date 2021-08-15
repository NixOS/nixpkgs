{ lib, buildPythonPackage, fetchPypi
, pbr
, stestr, oslotest, requests-mock, testscenarios, subunit }:

buildPythonPackage rec {
  pname = "os-service-types";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v4chwr5jykkvkv4w7iaaic7gb06j6ziw7xrjlwkcf92m2ch501i";
  };

  postPatch = ''
    # This test has circular dependency on keystoneauth1
    rm os_service_types/tests/test_remote.py
  '';

  propagatedBuildInputs = [
    pbr
  ];

  checkInputs = [ stestr oslotest requests-mock testscenarios subunit ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "os_service_types" ];


  meta = with lib; {
    description = "Library for consuming OpenStack sevice-types-authority data";
    homepage = "https://docs.openstack.org/os-service-types/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
