{ lib
, buildPythonPackage
, fetchPypi
, ntc-templates
, paramiko
, pyserial
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, scp
, tenacity
, textfsm
}:

buildPythonPackage rec {
  pname = "netmiko";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VwUZdHr82WsEprB7rk5d62AwaCxzngftDgjeBZW4OWQ=";
  };

  propagatedBuildInputs = [
    ntc-templates
    paramiko
    pyserial
    pyyaml
    setuptools
    scp
    tenacity
    textfsm
  ];

  # Tests require closed-source pyats and genie packages
  doCheck = false;

  pythonImportsCheck = [
    "netmiko"
  ];

  meta = with lib; {
    description = "Multi-vendor library to simplify Paramiko SSH connections to network devices";
    homepage = "https://github.com/ktbyers/netmiko/";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
  };
}
