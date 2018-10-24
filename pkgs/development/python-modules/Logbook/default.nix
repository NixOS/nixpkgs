{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "Logbook";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n8wzm2nc99gbvb44y2fbb59sy3c4awkwfgy4pbwv7z892ykw2iw";
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
