{ lib, buildPythonPackage, fetchPypi
, pbr, iso8601, oslo-i18n, pytz, netaddr, netifaces, debtcollector, pyparsing, packaging
, stestr, oslotest, ddt, testscenarios }:

buildPythonPackage rec {
  pname = "oslo-utils";
  version = "4.9.2";

  src = fetchPypi {
    inherit version;
    pname = "oslo.utils";
    sha256 = "1jd584n3yws3xpz7dj7v0axcgq5dj0kwpbx6sm83nv7z6ibjinr0";
  };

  postPatch = ''
    # Test requires network
    rm oslo_utils/tests/test_eventletutils.py
  '';

  propagatedBuildInputs = [
    pbr
    iso8601
    oslo-i18n
    pytz
    netaddr
    netifaces
    debtcollector
    pyparsing
    packaging
  ];

  checkInputs = [ stestr oslotest ddt testscenarios ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslo_utils" ];

  meta = with lib; {
    description = "Oslo Utility library";
    homepage = "https://docs.openstack.org/oslo.utils/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
