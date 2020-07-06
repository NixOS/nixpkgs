{ stdenv, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = with stdenv.lib; {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
