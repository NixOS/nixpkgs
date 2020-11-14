{ lib, fetchPypi, buildPythonPackage, colorama, isPy27 }:

buildPythonPackage rec {
  pname = "log_symbols";
  version = "0.0.14";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "zwu8b+Go5T8NF0pxa8YlxPhwQ8wh61XdinQM/iJoBVY=";
  };

  propagatedBuildInputs = [ colorama ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "log_symbols" ];

  meta = with lib; {
    description = "Colored symbols for various log levels";
    homepage    = "https://github.com/manrajgrover/py-log-symbols";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
