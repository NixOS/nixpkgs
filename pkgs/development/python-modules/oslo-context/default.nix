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
}:

buildPythonPackage rec {
  pname = "oslo.context";
  version = "2.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bdns9pljqlwh8xvpkw3bdq8zdi2hg86wxfgpddrbrlifnbnap14";
  };

  propagatedBuildInputs = [ pbr Babel ];
  checkInputs = [ coverage oslosphinx oslotest ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with lib; {
    description = "maintain useful information about a request context";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.context";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
