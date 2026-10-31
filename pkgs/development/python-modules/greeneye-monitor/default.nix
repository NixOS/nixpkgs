{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-socket,
  pytestCheckHook,
  siobrultech-protocols,
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
    tag = "v${version}";
    hash = "sha256-7EDuQ+wECcTzxkEufMpg3WSzosWeiwfxcVIVtQi+0BI=";
  };

  postPatch = ''
    cat >> pyproject.toml << EOF
    [build-system]
    requires = ["poetry-core"]
    build-backend = "poetry.core.masonry.api"
    EOF
  '';

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "siobrultech-protocols"
  ];

  dependencies = [
    aiohttp
    siobrultech-protocols
  ];

  nativeCheckInputs = [
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "greeneye.monitor" ];

  meta = {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    changelog = "https://github.com/jkeljo/greeneye-monitor/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
