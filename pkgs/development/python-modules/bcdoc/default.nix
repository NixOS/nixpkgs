{ lib, buildPythonPackage, fetchFromGitHub, docutils, six }:

buildPythonPackage rec {
  pname = "bcdoc";
  version = "0.16.0";

  src = fetchFromGitHub {
     owner = "boto";
     repo = "bcdoc";
     rev = "0.16.0";
     sha256 = "0m6w5rrfwmhdh8g90rapbc8v2d4ynwhqlpys7zwc0920yyjmgvfw";
  };

  buildInputs = [ docutils six ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/boto/bcdoc";
    license = licenses.asl20;
    description = "ReST document generation tools for botocore";
  };
}
