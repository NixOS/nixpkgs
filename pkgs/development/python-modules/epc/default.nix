{ lib
, buildPythonPackage
, fetchFromGitHub
, sexpdata
}:

buildPythonPackage rec {
  pname = "epc";
  version = "0.0.5";

  src = fetchFromGitHub {
     owner = "tkf";
     repo = "python-epc";
     rev = "v0.0.5";
     sha256 = "1r6g1s1xb5756wr4904h9c917mx7k7343ay89a5z2sqmg327l8ah";
  };

  propagatedBuildInputs = [ sexpdata ];
  doCheck = false;

  meta = with lib; {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = licenses.gpl3;
  };

}
