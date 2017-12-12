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
, statsd
}:

buildPythonPackage rec {
  pname = "oslo.middleware";
  version = "3.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06313mxzr5r1zn0l408jwgsbvxlhq14xxqrbdxnmbgj5am3ig8qb";
  };

  propagatedBuildInputs = [
    oslo-i18n six oslo-utils pbr oslo-config Babel oslo-context stevedore statsd
  ];
  checkInputs = [ coverage testtools oslosphinx oslotest oslo-serialization ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with lib; {
    description = "Oslo Middleware";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
