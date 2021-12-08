{ lib, buildPythonPackage, fetchFromGitHub, pyyaml }:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.2.0";

  src = fetchFromGitHub {
     owner = "rca";
     repo = "cmdline";
     rev = "0.2.0";
     sha256 = "1jda3hp3hdlzxk4p1z6g0x52pbf0w66llakddcn9874g8nsh4v65";
  };

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  propagatedBuildInputs = [ pyyaml ];

  meta = with lib; {
    description = "Utilities for consistent command line tools";
    homepage = "https://github.com/rca/cmdline";
    license = licenses.asl20;
  };
}
