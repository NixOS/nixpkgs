{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-spinner";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-spinner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v7mOC7pKBT6hejSZ4XPiogZ6LxPrui4npFe0picvYGY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    click
    pytestCheckHook
  ];

  pythonImportsCheck = [ "click_spinner" ];

  meta = {
    description = "Add support for showing that command line app is active to Click";
    homepage = "https://github.com/click-contrib/click-spinner";
    changelog = "https://github.com/click-contrib/click-spinner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
