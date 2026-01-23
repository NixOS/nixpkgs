{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.5.0";
  pyproject = true;

  # https://github.com/kwarunek/aiounittest/issues/28
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = "aiounittest";
    tag = version;
    hash = "sha256-zX3KpDw7AaEwOLkiHX/ZD+rSMeN7qi9hOVAmVH6Jxgg=";
  };

  build-system = [ setuptools ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiounittest" ];

  meta = {
    changelog = "https://github.com/kwarunek/aiounittest/releases/tag/${src.tag}";
    description = "Test asyncio code more easily";
    homepage = "https://github.com/kwarunek/aiounittest";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
