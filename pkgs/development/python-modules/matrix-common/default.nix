{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, attrs
}:

buildPythonPackage rec {
  pname = "matrix_common";
  version = "1.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YuEhzM2fJDQXtX7DenbcRK6xmKelxnr9a4J1mS/yq9E=";
  };

  propagatedBuildInputs = [ attrs ];
  pythonImportsCheck = [ "matrix_common" ];

  meta = with lib; {
    description = "Common utilities for Synapse, Sydent and Sygnal";
    homepage = "https://github.com/matrix-org/matrix-python-common";
    license = licenses.asl20;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
