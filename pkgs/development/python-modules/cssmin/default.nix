{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "cssmin";
  version = "0.2.0";

  src = fetchFromGitHub {
     owner = "zacharyvoase";
     repo = "cssmin";
     rev = "v0.2.0";
     sha256 = "04bzpal6j26pjjjf3p7iq6g2wcr61j4g0ygqz6h847h4hsyah9qg";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A Python port of the YUI CSS compression algorithm";
    homepage = "https://github.com/zacharyvoase/cssmin";
    license = licenses.bsd3;
  };
}
