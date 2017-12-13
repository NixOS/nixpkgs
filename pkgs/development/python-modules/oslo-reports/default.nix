{ lib, buildPythonPackage, fetchPypi
, python
, pbr, six
, oslo-i18n
, oslo-utils
, oslo-config
, oslo-context
, stevedore
, Babel
, coverage
, testtools
, oslosphinx
, oslotest
, oslo-serialization
, psutil, jinja2
, greenlet, eventlet
}:

buildPythonPackage rec {
  pname = "oslo.reports";
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q7v9r5yz2lvpp18dv3j629bkv7a8fg17arblap1ny62s548j47b";
  };

  propagatedBuildInputs = [ oslo-i18n oslo-utils oslo-serialization six psutil Babel jinja2 pbr ];
  checkInputs = [ coverage greenlet eventlet oslosphinx oslotest oslo-config ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with lib; {
    description = "generate Guru Meditation Reports for debugging the current state of OpenStack processes";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.reports";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
