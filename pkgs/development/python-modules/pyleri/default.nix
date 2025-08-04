{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyleri";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesbit";
    repo = "pyleri";
    tag = version;
    hash = "sha256-4t+6wtYzJbmL0TB/OXr89uZ2s8DeGlUdWwHd4YPsCW0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyleri" ];

  meta = with lib; {
    description = "Module to parse SiriDB";
    homepage = "https://github.com/cesbit/pyleri";
    changelog = "https://github.com/cesbit/pyleri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
