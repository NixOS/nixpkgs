{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  setuptools,
  typing-extensions,
  cached-property,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-datauri";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WrOQPUZ9vaLSR0hxIvCK8kBnARiOLh6qqWBw/h6XpaY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    typing-extensions
    cached-property
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datauri" ];

  meta = {
    description = "Module for Data URI manipulation";
    homepage = "https://github.com/fcurella/python-datauri";
    changelog = "https://github.com/fcurella/python-datauri/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
})
