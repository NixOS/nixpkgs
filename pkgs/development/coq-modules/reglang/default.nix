{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:

mkCoqDerivation {
  pname = "reglang";

  releaseRev = v: "v${v}";

  release."1.2.0".sha256 = "sha256-gSqQ7D2HLwM4oYopTWkMFYfYXxsH/7VxI3AyrLwNf3o=";
  release."1.1.3".sha256 = "sha256-kaselYm8K0JBsTlcI6K24m8qpv8CZ9+VNDJrOtFaExg=";
  release."1.1.2".sha256 = "sha256-SEnMilLNxh6a3oiDNGLaBr8quQ/nO2T9Fwdf/1il2Yk=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.coq-version mathcomp.version ] [
    { cases = [ (range "8.16" "8.18") (isGe "2.0.0") ]; out = "1.2.0"; }
    { cases = [ (range "8.10" "8.18") (isLt "2.0.0") ]; out = "1.1.3"; }
  ] null;


  propagatedBuildInputs = [ mathcomp.ssreflect ];

  meta = with lib; {
    description = "Regular Language Representations in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
