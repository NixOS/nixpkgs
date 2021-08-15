{ lib, buildPythonPackage, fetchPypi
, fixtures, subunit, six, testtools
, stestr }:

buildPythonPackage rec {
  pname = "oslotest";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r50sz55m8ljv2vk1k7sp88iz1iqq4p9w6kb8hn8g8c50r9zdi5i";
  };

  propagatedBuildInputs = [
    fixtures
    subunit
    six
    testtools
  ];

  checkInputs = [ stestr ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslotest" ];

  meta = with lib; {
    description = "Library for consuming OpenStack sevice-types-authority data";
    homepage = "https://docs.openstack.org/oslotest/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
