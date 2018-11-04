{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
, hypothesis
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.14.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f64dd1b706c31f7aa24495a7da58c0407c072981289b675331e2a16364355102";
  };

  propagatedBuildInputs = [ six ];
  buildInputs = [ pytest hypothesis ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tobgu/pyrsistent/;
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
