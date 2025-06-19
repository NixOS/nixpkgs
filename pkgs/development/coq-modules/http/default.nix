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
      inherit (lib.versions) isLe range;
    in
    lib.switch coq.coq-version (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: case: { inherit case out; }) {
        "0.2.1" = range "8.14" "8.19";
      }
    )) null;
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
