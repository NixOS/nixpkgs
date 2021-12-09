{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.9";

  src = fetchFromGitHub {
     owner = "makinacorpus";
     repo = "easydict";
     rev = "1.9";
     sha256 = "0nv0asrdixi16qmafvasmxprgja9g07gxk5fz87lw13n9bfjb9z7";
  };

  docheck = false; # No tests in archive

  meta = with lib; {
    homepage = "https://github.com/makinacorpus/easydict";
    license = licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
