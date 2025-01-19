{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "5.1.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = pname;
    tag = version;
    hash = "sha256-MI63b77ydmhQSbtKovla7BCEUjLF43DW80VABjAVEI0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_registry" ];

  meta = with lib; {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [
      hrdinka
    ];
  };
}
