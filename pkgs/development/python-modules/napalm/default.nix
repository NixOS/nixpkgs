{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
    tag = version;
    hash = "sha256-Abw3h69qTFwOOFeAfivqAIWLozErJ1yZZfx7CbMy1AI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/napalm-automation/napalm/commit/7e509869f7cb56892380629d1cb5f99e3e2c6190.patch";
      hash = "sha256-vJDACa5SmSJ/rcmKEow4Prqju/jYcCrzGpTdEYsAPq0=";
      includes = [
        "napalm/ios/ios.py"
      ];
    })
  ];

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
  };
}
