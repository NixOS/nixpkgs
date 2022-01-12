{ lib
, buildPythonApplication
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

buildPythonApplication rec {
  pname = "python-ironicclient";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f3ad8ae1fc4df524ea05a458ad2567b58144e881807dbbb985e282902d732fd";
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

  checkInputs = [
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
