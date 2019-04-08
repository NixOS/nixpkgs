{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.6.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5537b00afb7b247da0f59cc57ee5680178be61c8b2e21b5a0672b70a3d247791";
  };

  checkPhase = ''
    python -m ppft.tests
  '';

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Distributed and parallel python";
    homepage = https://github.com/uqfoundation;
    license = licenses.bsd3;
  };

}
