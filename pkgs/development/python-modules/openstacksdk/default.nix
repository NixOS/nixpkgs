{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, appdirs
, cryptography
, dogpile-cache
, jmespath
, jsonpatch
, keystoneauth1
, munch
, netifaces
, os-service-types
, pbr
, pyyaml
, requestsexceptions
, stdenv
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "0.59.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PfdgzScjmKv6yM6+Yu64LLxJe7JdTdcHV290qM6avw0=";
  };

  propagatedBuildInputs = [
    appdirs
    cryptography
    dogpile-cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    netifaces
    os-service-types
    pbr
    requestsexceptions
    pyyaml
  ];

  # Checks moved to 'passthru.tests' to workaround slowness
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "openstack" ];

  meta = with lib; {
    description = "An SDK for building applications to work with OpenStack";
    homepage = "https://github.com/openstack/openstacksdk";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
