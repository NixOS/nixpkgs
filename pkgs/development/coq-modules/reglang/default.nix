{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "reglang";

  releaseRev = v: "v${v}";

  release."1.2.2".sha256 = "sha256-js1JaLSpYbxfiAfh8XvGsnJpx5DV13heouUm3oeBfNg=";
  release."1.2.1".sha256 = "sha256-giCRK8wzpVVzXAkFAieQDWqSsP7upSJSUUHkwG4QqO4=";
  release."1.2.0".sha256 = "sha256-gSqQ7D2HLwM4oYopTWkMFYfYXxsH/7VxI3AyrLwNf3o=";
  release."1.1.3".sha256 = "sha256-kaselYm8K0JBsTlcI6K24m8qpv8CZ9+VNDJrOtFaExg=";
  release."1.1.2".sha256 = "sha256-SEnMilLNxh6a3oiDNGLaBr8quQ/nO2T9Fwdf/1il2Yk=";

  inherit version;
  defaultVersion =
    with lib.versions;
    let
      cmc = c: mc: [
        c
        mc
      ];
    in
    lib.switch [ coq.coq-version mathcomp.version ] (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: cases: { inherit cases out; }) {
        "1.2.2" = cmc (range "8.16" "9.0") (range "2.0.0" "2.4.0");
        "1.2.1" = cmc (range "8.16" "9.0") (range "2.0.0" "2.3.0");
        "1.2.0" = cmc (range "8.16" "8.18") (range "2.0.0" "2.1.0");
        "1.1.3" = cmc (range "8.10" "8.20") (isLt "2.0.0");
      }
    )) null;

  propagatedBuildInputs = [
    mathcomp.ssreflect
    stdlib
  ];

  meta = with lib; {
    description = "Regular Language Representations in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
