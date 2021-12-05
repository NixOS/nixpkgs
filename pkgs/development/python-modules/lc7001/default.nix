{ lib, buildPythonPackage, cryptography, fetchPypi, pythonOlder, poetry-core }:

buildPythonPackage rec {
  pname = "lc7001";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "NgnszlgmeUnfWs9onnboFRz3c4OibsNaZHjDINvoMPc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ cryptography ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "lc7001" ];

  meta = with lib; {
    description = "Python module for interacting with Legrand LC7001";
    homepage = "https://github.com/rtyle/lc7001";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
