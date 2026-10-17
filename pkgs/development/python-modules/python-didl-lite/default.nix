{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  defusedxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "python-didl-lite";
    tag = version;
    hash = "sha256-kzE3k1GXn+6dZTiywr4YYBrjmWY13ZQSRWL4N882+7U=";
  };

  build-system = [ setuptools ];

  dependencies = [ defusedxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "didl_lite" ];

  meta = {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    changelog = "https://github.com/StevenLooman/python-didl-lite/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
