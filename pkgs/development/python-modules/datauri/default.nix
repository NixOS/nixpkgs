{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  cached-property,
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    tag = "v${version}";
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

  meta = with lib; {
    description = "Module for Data URI manipulation";
    homepage = "https://github.com/fcurella/python-datauri";
    changelog = "https://github.com/fcurella/python-datauri/releases/tag/${src.tag}";
    license = licenses.unlicense;
    maintainers = [ ];
  };
}
