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
  version = "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2288d9607097a08529d9165970261c1be956934e8a8f6d9ed2a96d9b8f03fc6";
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
