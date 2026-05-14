{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyleri";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesbit";
    repo = "pyleri";
    tag = "v${version}";
    hash = "sha256-4t+6wtYzJbmL0TB/OXr89uZ2s8DeGlUdWwHd4YPsCW0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyleri" ];

  meta = {
    description = "Module to parse SiriDB";
    homepage = "https://github.com/cesbit/pyleri";
    changelog = "https://github.com/cesbit/pyleri/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
