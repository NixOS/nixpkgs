{ lib
, buildPythonApplication
, fetchPypi
, pbr
, appdirs
, cliff
, dogpile_cache
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
  version = "4.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99d45e914b2845731ac44fbfc63ae3e1bd52211396748797b588f2adc4b3f341";
  };

  propagatedBuildInputs = [
    pbr
    appdirs
    cliff
    dogpile_cache
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
