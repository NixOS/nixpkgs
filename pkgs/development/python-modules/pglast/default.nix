{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, pytest-cov
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bb74df084b149e8bf969380d88b1980fbd1aeda7f7057f4dee6751d854d6ae6";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytest pytest-cov ];

  pythonImportsCheck = [ "pglast" ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    changelog = "https://github.com/lelit/pglast/raw/v${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marsam ];
  };
}
