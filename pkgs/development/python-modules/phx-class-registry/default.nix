{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = "class-registry";
    tag = version;
    hash = "sha256-MI63b77ydmhQSbtKovla7BCEUjLF43DW80VABjAVEI0=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_registry" ];

  meta = with lib; {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
