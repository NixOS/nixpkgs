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
  version = "4.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b55516a72b995f92fb434619cbc1e2effa604c7fcaa6ac4afb8f5af1ea8193a4";
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
