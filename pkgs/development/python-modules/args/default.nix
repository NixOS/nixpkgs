{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "args";
  version = "0.1.0";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "args";
     rev = "v0.1.0";
     sha256 = "1n8ayb1gc6zp32qicj3y5b20sniqgb24i0gq33dp6wmv9yddm805";
  };

  meta = with lib; {
    description = "Command Arguments for Humans";
    homepage = "https://github.com/kennethreitz/args";
  };
}
