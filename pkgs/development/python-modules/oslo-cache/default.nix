{ lib, buildPythonPackage, fetchPypi
, python
, pbr, six
, oslo-i18n
, oslo-config
, oslo-utils
, oslo-log
, Babel
, dogpile_cache
, oslosphinx
, oslotest
, pymongo, memcached
}:

buildPythonPackage rec {
  pname = "oslo.cache";
  version = "1.27.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vmln4cr90fdcblnyrkwqgwbb4bjkc9w887r7parpg6ap892d035";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [
      Babel dogpile_cache six oslo-config oslo-i18n oslo-log oslo-utils
  ];
  checkInputs = [
      oslosphinx oslotest memcached pymongo
  ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  meta = with lib; {
    description = "a library for caching based on dogpile";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.cache";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
