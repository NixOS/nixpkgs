{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "Logbook";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nsnz9qdcba85q57qbam6skfvq2k7savn64qdy44cjnh0vkmqdrj";
  };

  checkInputs = [ pytest ] ++ lib.optionals (!isPy3k) [ mock ];

  propagatedBuildInputs = [ brotli ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  meta = {
    homepage = https://pythonhosted.org/Logbook/;
    description = "A logging replacement for Python";
    license = lib.licenses.bsd3;
  };
}
