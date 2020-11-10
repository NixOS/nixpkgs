{ lib, buildPythonPackage, fetchPypi, poetry, pytest }:

buildPythonPackage rec {
  pname = "pastel";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6581ac04e973cac858828c6202c1e1e81fee1dc7de7683f3e1ffe0bfd8a573d";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/sdispater/pastel";
    description = "Bring colors to your terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
