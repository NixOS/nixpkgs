{ stdenv, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91666032d6723dc5905248417ef0dc9e4c51df9526aaeef271eacad6491f06a4";
  };

  checkPhase = ''
    ${python.interpreter} test_parse.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/r1chardj0n3s/parse";
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
