{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

buildPythonPackage (finalAttrs: {
  pname = "napalm";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napalm-automation";
    repo = "napalm";
    tag = finalAttrs.version;
    hash = "sha256-kIQgr5W9xkdcQkscJkOiABJ5HBxZOT9D7jSKWGNoBGA=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Network Automation and Programmability Abstraction Layer with Multivendor support";
    homepage = "https://github.com/napalm-automation/napalm";
    license = lib.licenses.asl20;
  };
})
