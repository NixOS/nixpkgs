{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.1.0";

  src = fetchFromGitHub {
     owner = "nucleic";
     repo = "cppy";
     rev = "1.1.0";
     sha256 = "1jlnrhrplhvi0p4ymak2lcv1wg3npf0np86vb911rj05fnplpwly";
  };

  # Headers-only library, no tests
  doCheck = false;

  # Not supported
  disabled = !isPy3k;

  meta = {
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}
