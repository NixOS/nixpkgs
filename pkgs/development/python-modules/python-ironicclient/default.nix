{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cliff,
  dogpile-cache,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  openstacksdk,
  osc-lib,
  oslo-utils,
  oslotest,
  pbr,
  platformdirs,
  pyyaml,
  requests,
  requests-mock,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-ironicclient";
  version = "5.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-ironicclient";
    tag = version;
    hash = "sha256-Mang/QJAgkxiKnwx8+q37hy+aRAnsw2uOQgniO545yc=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxcontrib-apidoc
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    dogpile-cache
    jsonschema
    keystoneauth1
    openstacksdk
    osc-lib
    oslo-utils
    pbr
    platformdirs
    pyyaml
    requests
    stevedore
  ];

  nativeCheckInputs = [
    stestr
    requests-mock
    oslotest
  ];

  env.PBR_VERSION = version;

  checkPhase = ''
    runHook preCheck
    stestr run -e <(echo "
      ironicclient.tests.unit.osc.v1.test_baremetal_chassis.TestChassisCreate.test_chassis_create_no_options
      ironicclient.tests.unit.osc.v1.test_baremetal_chassis.TestChassisCreate.test_chassis_create_with_description
      ironicclient.tests.unit.osc.v1.test_baremetal_chassis.TestChassisCreate.test_chassis_create_with_extra
      ironicclient.tests.unit.osc.v1.test_baremetal_chassis.TestChassisCreate.test_chassis_create_with_uuid
      ironicclient.tests.unit.osc.v1.test_baremetal_conductor.TestBaremetalConductorShow.test_conductor_show
      ironicclient.tests.unit.osc.v1.test_baremetal_node.TestBaremetalCreate
      ironicclient.tests.unit.osc.v1.test_baremetal_node.TestBaremetalShow.test_baremetal_show
      ironicclient.tests.unit.osc.v1.test_baremetal_node.TestNodeHistoryEventGet.test_baremetal_node_history_list
    ")
    runHook postCheck
  '';

  pythonImportsCheck = [ "ironicclient" ];

  meta = with lib; {
    description = "Client for OpenStack bare metal provisioning API, includes a Python module (ironicclient) and CLI (baremetal)";
    mainProgram = "baremetal";
    homepage = "https://github.com/openstack/python-ironicclient";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
