{ stdenv, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = with stdenv.lib; {
    description = "C parser in Python";
    homepage = https://github.com/eliben/pycparser;
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
