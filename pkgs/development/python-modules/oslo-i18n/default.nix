{ lib, buildPythonPackage, fetchPypi
, pbr, six
, stestr, oslotest, testscenarios }:

buildPythonPackage rec {
  pname = "oslo-i18n";
  version = "5.0.1";

  src = fetchPypi {
    inherit version;
    pname = "oslo.i18n";
    sha256 = "0nq3dr2kbrawqvp9q9i8i44z9jliq98i2b9h4dsl6p7p60gbg11l";
  };

  propagatedBuildInputs = [
    pbr
    six
  ];

  checkInputs = [ stestr oslotest testscenarios ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslo_i18n" ];

  meta = with lib; {
    description = "Oslo i18n library";
    homepage = "https://docs.openstack.org/oslo.i18n/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
