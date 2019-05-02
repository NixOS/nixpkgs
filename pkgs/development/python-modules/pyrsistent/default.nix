{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
, hypothesis
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ar7li76q10iiir6z72jd6apldlzb286hrxmnmr4bzsm9mzx60sl";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest hypothesis ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tobgu/pyrsistent/;
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
