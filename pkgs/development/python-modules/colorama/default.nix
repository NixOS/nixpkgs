{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.4";

  src = fetchFromGitHub {
     owner = "tartley";
     repo = "colorama";
     rev = "0.4.4";
     sha256 = "0m45zy6h6ab5137b9qpkx2m9kd55rfm4yzbja676cd58cwbp01jy";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tartley/colorama";
    license = licenses.bsd3;
    description = "Cross-platform colored terminal text";
  };
}

