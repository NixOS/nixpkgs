{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "eradicate";
  version = "2.0.0";

  src = fetchFromGitHub {
     owner = "myint";
     repo = "eradicate";
     rev = "v2.0.0";
     sha256 = "18vbahs105gznwdymnb9j0vwdk6f7hby7harf7nr2lsjia61pgah";
  };

  meta = with lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = "https://github.com/myint/eradicate";
    license = [ licenses.mit ];

    maintainers = [ maintainers.mmlb ];
  };
}
