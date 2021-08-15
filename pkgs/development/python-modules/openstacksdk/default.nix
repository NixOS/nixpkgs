{ lib, buildPythonPackage, fetchPypi
, pbr, pyyaml, appdirs, requestsexceptions, jsonpatch, os-service-types, keystoneauth1, munch, decorator, jmespath, iso8601, netifaces, dogpile_cache, cryptography, importlib-metadata }:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "0.58.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y520jd7nanjqp92ljs2w7x2j5ppxviwhb6j2d1131pn50bqsdnq";
  };

  propagatedBuildInputs = [
    pbr
    pyyaml
    appdirs
    requestsexceptions
    jsonpatch
    os-service-types
    keystoneauth1
    munch
    decorator
    jmespath
    iso8601
    netifaces
    dogpile_cache
    cryptography
    importlib-metadata
  ];

  # Of ~3800 tests, ~10 are flaky. Maybe at some point this will be fixed and we can enable checks
  doCheck = false;
  pythonImportsCheck = [ "openstack" ];

  meta = with lib; {
    description = "An SDK for building applications to work with OpenStack";
    homepage = "https://docs.openstack.org/openstacksdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
