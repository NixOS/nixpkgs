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
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fjwnxg7q1b02j7hk1wqm5xdn7wck9j2g3ggkkizab6l77kjws8n";
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
