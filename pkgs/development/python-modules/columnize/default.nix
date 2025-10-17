{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

let
  pname = "columnize";
  version = "0.3.11";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pjG4Y7MQpsFFdim3vzKjd36lpAf4mFMRzowkwx0di7I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "columnize" ];

  meta = {
    description = "Python module to align a simple (not nested) list in columns";
    homepage = "https://github.com/rocky/pycolumnize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
