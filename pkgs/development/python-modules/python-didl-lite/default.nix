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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "python-didl-lite";
    tag = version;
    hash = "sha256-pdXdGRycMB6M6qnPl+Z+ezRw6td45IqYkEpx4YtL1rQ=";
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
