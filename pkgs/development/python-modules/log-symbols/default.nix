{
  buildPythonPackage,
  colorama,
  fetchPypi,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "log_symbols";
  version = "0.0.14";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zwu8b+Go5T8NF0pxa8YlxPhwQ8wh61XdinQM/iJoBVY=";
  };

  propagatedBuildInputs = [ colorama ];

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;
  pythonImportsCheck = [ "log_symbols" ];

  meta = with lib; {
    description = "Colored Symbols for Various Log Levels";
    homepage = "https://github.com/manrajgrover/py-log-symbols";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
