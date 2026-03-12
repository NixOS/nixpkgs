{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  aiohttp,
  requests,
  pexpect,
  systemd-python,
  paramiko,
  pyserial,
  hidapi,
  pysnmp,
  pyasn1,
  pyusb,
  pymodbus,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "pdudaemon";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdudaemon";
    repo = "pdudaemon";
    tag = "${finalAttrs.version}";
    hash = "sha256-TfBXuNhuxXjNI1XDtJ3DSqKxq3nbWDiZSVsY3EUEBlY=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    pexpect
    requests
    pexpect
    systemd-python
    paramiko
    pyserial
    hidapi
    pysnmp
    pyasn1
    pyusb
    pymodbus
  ];

  passthru.updateScripts = gitUpdater { };

  pythonImportsCheck = [ "pdudaemon" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pdudaemon/pdudaemon/releases/tag/${finalAttrs.src.tag}";
    description = "Python Daemon for controlling/sequentially executing commands to PDUs (Power Distribution Units)";
    homepage = "https://github.com/pdudaemon/pdudaemon";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ aiyion ];
  };
})
