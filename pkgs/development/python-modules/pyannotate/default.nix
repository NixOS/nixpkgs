{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy-extensions,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "pyannotate";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BO1YBLqzgVPVmB/JLYPc9qIog0U3aFYfBX53flwFdZk=";
  };

  propagatedBuildInputs = [
    six
    mypy-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pyannotate_runtime"
    "pyannotate_tools"
  ];

  meta = with lib; {
    description = "Auto-generate PEP-484 annotations";
    mainProgram = "pyannotate";
    homepage = "https://github.com/dropbox/pyannotate";
    license = licenses.mit;
    maintainers = [ ];
  };
}
