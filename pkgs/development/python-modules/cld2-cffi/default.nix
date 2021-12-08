{ lib, stdenv, buildPythonPackage, fetchFromGitHub, six, cffi, nose }:

buildPythonPackage rec {
  pname = "cld2-cffi";
  version = "0.1.4";

  src = fetchFromGitHub {
     owner = "GregBowyer";
     repo = "cld2-cffi";
     rev = "0.1.4";
     sha256 = "0mk09idn8rdmb8q31fdf3gr8dxywmc0jzp9z6hmh6pw553inspc3";
  };

  propagatedBuildInputs = [ six cffi ];
  checkInputs = [ nose ];

  # gcc doesn't approve of this code, so disable -Werror
  NIX_CFLAGS_COMPILE = "-w" + lib.optionalString stdenv.cc.isClang " -Wno-error=c++11-narrowing";

  checkPhase = "nosetests -v";

  meta = with lib; {
    description = "CFFI bindings around Google Chromium's embedded compact language detection library (CLD2)";
    homepage = "https://github.com/GregBowyer/cld2-cffi";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
