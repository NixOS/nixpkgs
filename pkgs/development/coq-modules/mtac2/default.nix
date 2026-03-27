{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  unicoq,
  version ? null,
}:

mkCoqDerivation {
  pname = "Mtac2";
  owner = "Mtac2";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.19" "9.0";
        out = "1.4-coq${coq.coq-version}";
      }
    ] null;
  release."1.4-coq9.0".sha256 = "sha256-pAPBRCW7M46UZPJ+v/0xAT8mpQURN8czMmlrfYz/MVU=";
  release."1.4-coq8.20".sha256 = "sha256-3nu/8zDvdnl6WzGtw46mVcdqgkRgc6Xy8/I+lUOrSIY=";
  release."1.4-coq8.19".sha256 = "sha256-G9eK0eLyECdT20/yf8yyz7M8Xq2WnHHaHpxVGP0yTtU=";
  releaseRev = v: "v${v}";
  mlPlugin = true;
  propagatedBuildInputs = [
    stdlib
    unicoq
  ];
  meta = {
    description = "Typed tactic language for Coq";
    license = lib.licenses.mit;
  };
  preBuild = ''
    coq_makefile -f _CoqProject -o Makefile
    patchShebangs tests/sf-5/configure.sh
  '';
}
