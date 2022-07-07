{ lib, mkCoqDerivation, coq, ssreflect, version ? null }:
with lib;

mkCoqDerivation {
  pname = "reglang";

  releaseRev = v: "v${v}";

  release."1.1.2".sha256 = "sha256-SEnMilLNxh6a3oiDNGLaBr8quQ/nO2T9Fwdf/1il2Yk=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.10" "8.15"; out = "1.1.2"; }
  ] null;


  propagatedBuildInputs = [ ssreflect ];

  meta = {
    description = "Regular Language Representations in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
