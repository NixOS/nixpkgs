{ lib, buildPythonPackage, fetchFromGitHub, callPackage, setuptools, cffi
, paramiko, requests, future, textfsm, jinja2, netaddr, pyyaml, pyeapi, netmiko
, junos-eznc, ciscoconfparse, scp, lxml, ncclient, pytestCheckHook, ddt, mock }:

buildPythonPackage rec {
  pname = "napalm";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "napalm-automation";
    repo = "napalm";
    rev = version;
    sha256 = "15h1h1a3avv48i14x96b8v7zkhmwg7dnzxycxr18f9530j237rq6";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [
    cffi
    paramiko
    requests
    future
    textfsm
    jinja2
    netaddr
    pyyaml
    pyeapi
    netmiko
    junos-eznc
    ciscoconfparse
    scp
    lxml
    ncclient
  ];

  checkInputs = [ pytestCheckHook mock ddt ];

  meta = with lib; {
    description =
      "Network Automation and Programmability Abstraction Layer with Multivendor support";
    homepage = "https://github.com/napalm-automation/napalm";
    license = licenses.asl20;
    maintainers = [ maintainers.astro ];
  };
}
