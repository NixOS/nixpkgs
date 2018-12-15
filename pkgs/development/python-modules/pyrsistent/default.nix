{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
, hypothesis
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.11.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jgyhkkq36wn36rymn4jiyqh2vdslmradq4a2mjkxfbk2cz6wpi5";
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
