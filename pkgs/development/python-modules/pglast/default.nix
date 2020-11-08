{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonOlder
, setuptools
, aenum
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5d6a105928d2285e43afb87d638ada844ed8933cc306c23a3c095684f3d3af4";
  };

  disabled = !isPy3k;

  requiredPythonModules = [ setuptools ] ++ lib.optionals (pythonOlder "3.6") [ aenum ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marsam ];
  };
}
