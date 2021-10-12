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
  version = "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1594d536137b888556b7187d25355ba88b3a14ef0d8aacccef15bfed74cf0af9";
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
