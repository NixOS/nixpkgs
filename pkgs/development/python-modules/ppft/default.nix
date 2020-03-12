{ stdenv
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.6.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e2173042edd5cc9c7bee0d7731873f17fcdce0e42e4b7ab68857d0de7b631fc";
  };

  propagatedBuildInputs = [ six ];

  # darwin seems to hang
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    cd examples
    ${python.interpreter} -m ppft.tests
  '';

  meta = with stdenv.lib; {
    description = "Distributed and parallel python";
    homepage = https://github.com/uqfoundation;
    license = licenses.bsd3;
  };

}
