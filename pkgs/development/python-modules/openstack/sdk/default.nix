{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pbr, pyyaml, appdirs, requestsexceptions, jsonpatch, openstack-os-service-types, openstack-keystoneauth1, munch, decorator, jmespath, iso8601, netifaces, dogpile_cache, cryptography, importlib-metadata
}:

buildPythonPackage rec {
  pname = "openstack-sdk";
  version = "0.59.0";

  src = fetchPypi {
    pname = "openstacksdk";
    inherit version;
    sha256 = "3df760cd272398abfac8cebe62eeb82cbc497bb25d4dd707576f74a8ce9abf0d";
  };

  propagatedBuildInputs = [
    pbr
    pyyaml
    appdirs
    requestsexceptions
    jsonpatch
    openstack-os-service-types
    openstack-keystoneauth1
    munch
    decorator
    jmespath
    iso8601
    netifaces
    dogpile_cache
    cryptography
  ];

  doCheck = false;

  pythonImportsCheck = [ "openstack" ];

  meta = with lib; {
    description = "An SDK for building applications to work with OpenStack";
    downloadPage = "https://pypi.org/project/openstacksdk/";
    homepage = "https://docs.openstack.org/openstacksdk/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj];
  };
}
