{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "phx-class-registry";
  version = "5.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = "class-registry";
    tag = version;
    hash = "sha256-lZxnZiCR2ZhEUTKH8Udmcp6VvISregGSBmwt5cqdQqo=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_registry" ];

  meta = {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
