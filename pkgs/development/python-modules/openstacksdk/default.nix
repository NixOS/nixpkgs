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
, pythonOlder
, pyyaml
, requestsexceptions
}:

buildPythonPackage rec {
  pname = "openstacksdk";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-FBtR+ijGsc3rmOvcOMHO5qTnVL1ryEq3qqDQwrzlRD4=";
=======
    hash = "sha256-zU0fxSMijgy5MIAA80vnwgTqsUvSeN3BFu76R9aNdJY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  pythonImportsCheck = [
    "openstack"
  ];

  meta = with lib; {
    description = "An SDK for building applications to work with OpenStack";
    homepage = "https://github.com/openstack/openstacksdk";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
