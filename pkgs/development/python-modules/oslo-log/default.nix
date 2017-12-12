{ stdenv, buildPythonPackage, fetchPypi
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
, oslotest, iso8601, debtcollector, dateutil
, oslo-serialization, pyinotify
}:

buildPythonPackage rec {
  pname = "oslo.log";
  version = "3.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16fs9mxwchd15v7gwgz28jifxdzsga8vllgspcrgdvlhxfwbzlxr";
  };

  propagatedBuildInputs = [
    pbr Babel six iso8601 debtcollector dateutil
    oslo-utils oslo-i18n oslo-config oslo-serialization oslo-context
  ] ++ stdenv.lib.optional stdenv.isLinux pyinotify;

  checkInputs = [ coverage oslosphinx oslotest ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with stdenv.lib; {
    description = "a logging configuration library";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.log";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
