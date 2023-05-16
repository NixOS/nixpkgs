{ lib
, buildPythonPackage
, fetchPypi
, pbr
, appdirs
, cliff
, dogpile-cache
, jsonschema
, keystoneauth1
, openstacksdk
, osc-lib
, oslo-utils
, pyyaml
, requests
, stevedore
, stestr
, requests-mock
, oslotest
}:

buildPythonPackage rec {
  pname = "python-ironicclient";
<<<<<<< HEAD
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q9yGuYf9TS7RCo9aV1hnNSrHoll7AOUiSpzRYxi+JXU=";
=======
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yYmzZuwZSasN6g6Bosivexe5oOy3dP+l/cD5TkXC87g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pbr
    appdirs
    cliff
    dogpile-cache
    jsonschema
    keystoneauth1
    openstacksdk
    osc-lib
    oslo-utils
    pyyaml
    requests
    stevedore
  ];

  nativeCheckInputs = [
    stestr
    requests-mock
    oslotest
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "ironicclient" ];

  meta = with lib; {
    description = "A client for OpenStack bare metal provisioning API, includes a Python module (ironicclient) and CLI (baremetal).";
    homepage = "https://github.com/openstack/python-ironicclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
