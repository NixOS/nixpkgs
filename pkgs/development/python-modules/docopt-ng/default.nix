{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "docopt-ng";
  version = "0.7.2";

  src = fetchFromGitHub {
     owner = "bazaar-projects";
     repo = "docopt-ng";
     rev = "0.7.2";
     sha256 = "0cwj40pfd6s4jw1hshcjrbalsqz537sv0pakb588cgl4k97wvnl1";
  };

  pythonImportsCheck = [ "docopt" ];
  doCheck = false; # no tests in the package

  meta = with lib; {
    description = "More-magic command line arguments parser. Now with more maintenance!";
    homepage = "https://github.com/bazaar-projects/docopt-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
