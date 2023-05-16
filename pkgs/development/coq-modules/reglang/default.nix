{ lib, mkCoqDerivation, coq, ssreflect, version ? null }:

mkCoqDerivation {
  pname = "reglang";

  releaseRev = v: "v${v}";

<<<<<<< HEAD
  release."1.1.3".sha256 = "sha256-kaselYm8K0JBsTlcI6K24m8qpv8CZ9+VNDJrOtFaExg=";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  release."1.1.2".sha256 = "sha256-SEnMilLNxh6a3oiDNGLaBr8quQ/nO2T9Fwdf/1il2Yk=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
<<<<<<< HEAD
    { case = range "8.10" "8.18"; out = "1.1.3"; }
=======
    { case = range "8.10" "8.16"; out = "1.1.2"; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] null;


  propagatedBuildInputs = [ ssreflect ];

  meta = with lib; {
    description = "Regular Language Representations in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
