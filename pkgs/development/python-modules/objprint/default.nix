{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "objprint";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaogaotiantian";
    repo = "objprint";
    tag = version;
    hash = "sha256-+OS034bikrKy4F27b6ic97fHTW6rSMxQ0dx4caF6cUM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "objprint" ];

  meta = {
    description = "Library that can print Python objects in human readable format";
    homepage = "https://github.com/gaogaotiantian/objprint";
    changelog = "https://github.com/gaogaotiantian/objprint/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
