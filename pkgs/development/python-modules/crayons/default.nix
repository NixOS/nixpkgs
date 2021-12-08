{ lib, fetchFromGitHub, buildPythonPackage, colorama }:

buildPythonPackage rec {
  pname = "crayons";
  version = "0.4.0";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "crayons";
     rev = "v0.4.0";
     sha256 = "0zmls5c67mxyxzlwvagiidlrxy1f6f8kwm5afjsydhn19h4rd7za";
  };

  propagatedBuildInputs = [ colorama ];

  meta = with lib; {
    description = "TextUI colors for Python";
    homepage = "https://github.com/kennethreitz/crayons";
    license = licenses.mit;
  };
}
