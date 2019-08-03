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
  version = "0.14.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ca82748918eb65e2d89f222b702277099aca77e34843c5eb9d52451173970e2";
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
