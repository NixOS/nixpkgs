{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  cffi,

  # dependencies
  jinja2,
  junos-eznc,
  lxml,
  ncclient,
  netaddr,
  netmiko,
  netutils,
  paramiko,
  pyeapi,
  pyyaml,
  requests,
  scp,
  textfsm,
  ttp,
  ttp-templates,
  typing-extensions,

  # tests
  pytestCheckHook,
  ddt,
  mock,
}:

buildPythonPackage rec {
  pname = "napalm";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "napalm-automation";
    repo = "napalm";
    rev = "refs/tags/${version}";
    hash = "sha256-Abw3h69qTFwOOFeAfivqAIWLozErJ1yZZfx7CbMy1AI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cffi
    jinja2
    junos-eznc
    lxml
    ncclient
    netaddr
    netmiko
    # breaks infinite recursion
    (netutils.override { napalm = null; })
    paramiko
    pyeapi
    pyyaml
    requests
    scp
    setuptools
    textfsm
    ttp
    ttp-templates
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    ddt
  ];

  meta = with lib; {
    description = "Network Automation and Programmability Abstraction Layer with Multivendor support";
    homepage = "https://github.com/napalm-automation/napalm";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
  };
}
