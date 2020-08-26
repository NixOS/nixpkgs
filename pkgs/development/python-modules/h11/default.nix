{ lib, buildPythonPackage, fetchPypi, pytest, fetchpatch }:

buildPythonPackage rec {
  pname = "h11";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qfad70h59hya21vrzz8dqyyaiqhac0anl2dx3s3k80gpskvrm1k";
  };

  patches = [
    # pytest5 compatability
    (fetchpatch {
      url = "https://github.com/python-hyper/h11/commit/241e220493a511a5f5a5d472cb88d72661a92ab1.patch";
      sha256 = "1s3ipf9s41m1lksws3xv3j133q7jnjdqvmgk4sfnm8q7li2dww39";
    })
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    license = licenses.mit;
  };
}
