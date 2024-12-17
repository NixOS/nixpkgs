{
  coq,
  mkCoqDerivation,
  lib,
  version ? null,
}@args:
(mkCoqDerivation {

  pname = "stdlib";
  repo = "coq";
  owner = "coq";
  opam-name = "coq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch
      [ coq.version ]
      [
        {
          cases = [ (isLt "8.21") ];
          out = "8.20";
        }
      ]
      null;
  releaseRev = v: "v${v}";

  release."8.20".sha256 = "sha256-AcoS4edUYCfJME1wx8UbuSQRF3jmxhArcZyPIoXcfu0=";

  useDune = true;

  configurePhase = ''
    echo "no configure phase"
  ''; # don't run Coq's configure

  preBuild = ''
    echo "(dirs stdlib)" > dune
  '';

  meta = {
    description = "Coq Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}).overrideAttrs
  (
    o:
    # stdlib is already included in Coq <= 8.20
    lib.optionalAttrs
      (coq.version != null && coq.version != "dev" && lib.versions.isLt "8.21" coq.version)
      {
        buildPhase = ''
          echo building nothing
        '';
        installPhase = ''
          touch $out
        '';
      }
  )
