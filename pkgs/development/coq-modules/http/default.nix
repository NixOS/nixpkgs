{
  lib,
  mkCoqDerivation,
  coq,
  QuickChick,
  async-test,
  version ? null,
}:

mkCoqDerivation {
  pname = "http";
  owner = "liyishuai";
  repo = "coq-http";
  inherit version;

  defaultVersion =
    let
      case = case: out: { inherit case out; };
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      (case (range "8.14" "8.19") "0.2.1")
    ] null;
  release = {
    "0.2.1".sha256 = "sha256-CIcaXEojNdajXNoMBjGlQRc1sOJSKgUlditNxbNSPgk=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    QuickChick
    async-test
  ];

  configurePhase = ''
    sed -e 's/^	install extract.*//' -i Makefile
  '';

  meta = {
    description = "HTTP specification in Coq, testable and verifiable";
    license = lib.licenses.mpl20;
  };
}
