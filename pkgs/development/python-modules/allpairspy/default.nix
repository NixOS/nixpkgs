{ lib, buildPythonPackage, fetchFromGitHub, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.0";

  src = fetchFromGitHub {
     owner = "thombashi";
     repo = "allpairspy";
     rev = "v2.5.0";
     sha256 = "1xdmvsq99jf687p44iwzzadlhqv0w2rffr3am127i7d80xj2w5bg";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = "https://github.com/thombashi/allpairspy";
    license = licenses.mit;
  };
}
