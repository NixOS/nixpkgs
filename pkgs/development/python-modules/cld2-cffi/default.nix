{ lib, stdenv, buildPythonPackage, fetchPypi, six, cffi, nose }:

buildPythonPackage rec {
  pname = "cld2-cffi";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rvcdx4fdh5yk4d2nlddq1q1r2r0xqp86hpmbdn447pdcj1r8a9s";
  };

  propagatedBuildInputs = [ six cffi ];
  nativeCheckInputs = [ nose ];

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
