{
  lib,
  adb-shell,
  alive-progress,
  buildPythonPackage,
  fetchFromGitHub,
  hatasm,
  manuf,
  netaddr,
  netifaces,
  paramiko,
  pefile,
  pyasyncore,
  pychromecast,
  pydantic,
  pyopenssl,
  pysnmp,
  requests,
  scapy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pex-entysec";
  version = "1.0.0-unstable-2024-10-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntySec";
    repo = "Pex";
    # https://github.com/EntySec/Pex/issues/11
    rev = "0a776da9afc1a88fcb74fac96648666748b3d965";
    hash = "sha256-37NoQL/BieMoZbaRiIu9QVAO2SEt7QQFPZ+KHzv3dRk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    adb-shell
    alive-progress
    hatasm
    manuf
    netaddr
    netifaces
    paramiko
    pefile
    pyasyncore
    pychromecast
    pydantic
    pyopenssl
    pysnmp
    requests
    scapy
  ];

  pythonImportsCheck = [ "pex" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Collection of special tools for providing high quality penetration testing using pure python programming language";
    homepage = "https://github.com/EntySec/Pex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
