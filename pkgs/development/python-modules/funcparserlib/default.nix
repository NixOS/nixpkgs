{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "funcparserlib";
  version = "0.3.6";

  src = fetchFromGitHub {
     owner = "vlasovskikh";
     repo = "funcparserlib";
     rev = "0.3.6";
     sha256 = "00fxdkrgap8cgsy983id1xj8mhlddg9gjwcy6vsz5zjj8byglhk8";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # Tests are Python 2.x only judging from SyntaxError
  doCheck = !(isPy3k);

  meta = with lib; {
    description = "Recursive descent parsing library based on functional combinators";
    homepage = "https://github.com/vlasovskikh/funcparserlib";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
