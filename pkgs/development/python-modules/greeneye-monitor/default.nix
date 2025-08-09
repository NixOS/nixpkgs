{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  siobrultech-protocols,
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
    tag = "v${version}";
    hash = "sha256-7EDuQ+wECcTzxkEufMpg3WSzosWeiwfxcVIVtQi+0BI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    siobrultech-protocols
  ];

  nativeCheckInputs = [
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "greeneye.monitor" ];

  meta = with lib; {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    changelog = "https://github.com/jkeljo/greeneye-monitor/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
