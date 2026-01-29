{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  babel,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "py-moneyed";
  version = "3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SQbw8CzyuR7bouFW8tTpp48iQFmrjI+i/yYjDHXYlOg=";
  };

  dependencies = [
    babel
    typing-extensions
  ];

  pythonImportsCheck = [ "moneyed" ];

  build-system = [ setuptools ];

  meta = {
    description = "Provides Currency and Money classes for use in your Python code.";
    homepage = "https://github.com/py-moneyed/py-moneyed";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
}
