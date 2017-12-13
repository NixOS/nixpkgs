{ lib, buildPythonPackage, fetchPypi
, python
, funcsigs
, pyparsing
, debtcollector
, netifaces
, netaddr
, pytz
, monotonic
, oslo-i18n
, iso8601
, six
, pbr
, coverage
, oslotest
, oslosphinx
, mock
, ddt
}:

buildPythonPackage rec {
  pname = "oslo.utils";
  version = "3.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gkp8lv1sd03q8mxjxcbaqkkv9v2aa7bx8nxic3q19ajd1i0h6rb";
  };

  propagatedBuildInputs = [
    funcsigs
    pyparsing
    debtcollector
    netifaces
    netaddr
    pytz
    monotonic
    oslo-i18n
    iso8601
    six
    pbr
  ];

  checkInputs = [ coverage oslosphinx oslotest mock ddt ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with lib; {
    description = "helper library that provides various low-level utility modules/code";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
