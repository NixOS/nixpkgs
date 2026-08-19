{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-flatten";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "json-flatten";
    tag = version;
    hash = "sha256-zAaunWuFAokC16FwHRHgyvq27pNUEGXJfSqTQ1wvXE8=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json_flatten"
  ];

  meta = {
    description = "Functions for flattening a JSON object to a single dictionary of pairs";
    license = lib.licenses.asl20;
    homepage = "https://github.com/simonw/json-flatten";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    changelog = "https://github.com/simonw/json-flatten/releases/tag/${version}";
  };
}
