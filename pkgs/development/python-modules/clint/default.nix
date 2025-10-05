{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  args,
}:

buildPythonPackage rec {
  pname = "clint";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BSJMMrEHVWPQsW0AFfqvnaQ6ohTkohQOUfCHieekxao=";
  };

  build-system = [ setuptools ];

  dependencies = [ args ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "clint" ];

  meta = with lib; {
    homepage = "https://github.com/kennethreitz/clint";
    description = "Python Command Line Interface Tools";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
