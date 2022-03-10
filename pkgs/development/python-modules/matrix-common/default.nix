{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, attrs
}:

buildPythonPackage rec {
  pname = "matrix_common";
  version = "1.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qCOHSK/Cs3B5gYNn/tUVbzVXcbB8j/ChdZNPR+D/MnY=";
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
