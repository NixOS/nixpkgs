{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.4";

  src = fetchFromGitHub {
     owner = "ICRAR";
     repo = "ijson";
     rev = "v3.1.4";
     sha256 = "0bf2r8l52q5ayar32q0k9x7nykyj5l8ra90mvlc8byrgxnzaf3wh";
  };

  doCheck = false; # something about yajl

  meta = with lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
