{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, setuptools, cffi
, paramiko, requests, future, textfsm, jinja2, netaddr, pyyaml, pyeapi, netmiko
, junos-eznc, ciscoconfparse, scp, lxml, ncclient, pytestCheckHook, ddt, mock
, pythonOlder, invoke }:

buildPythonPackage rec {
  pname = "napalm";
  version = "3.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "napalm-automation";
    repo = "napalm";
    rev = version;
    sha256 = "sha256-TNWRJtc6+VS6wgJGGvCPDoFQmOKQAyXdjFQo9bPJ2F8=";
  };

  patches = [
    # netmiko 4.0.0 support
    (fetchpatch{
      url = "https://github.com/napalm-automation/napalm/commit/4b8cc85db3236099a04f742cf71773e74d9dd70e.patch";
      excludes = [ "requirements.txt" ];
      sha256 = "sha256-DBKp+wiKd+/j2xAqaQL3UCcGQd6wnWcNTsNXBBt9c98=";
    })
    (fetchpatch{
      url = "https://github.com/napalm-automation/napalm/commit/4a8b5b1823335dd79aa5269c038a1f08ecd35cdd.patch";
      sha256 = "sha256-uiou/rzmnFf4wAvXwmUsGJx99GeHWKJB2JrMM1kLakM=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "netmiko>=3.3.0,<4.0.0" "netmiko"
  '';

  propagatedBuildInputs = [
    cffi
    paramiko
    requests
    future
    textfsm
    invoke
    jinja2
    netaddr
    pyyaml
    pyeapi
    netmiko
    junos-eznc
    ciscoconfparse
    scp
    setuptools
    lxml
    ncclient
  ];

  nativeCheckInputs = [ pytestCheckHook mock ddt ];

  meta = with lib; {
    description =
      "Network Automation and Programmability Abstraction Layer with Multivendor support";
    homepage = "https://github.com/napalm-automation/napalm";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
  };
}
