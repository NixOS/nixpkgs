{
  lib,
  mkCoqDerivation,
  rocqPackages,
  which,
  coq,
  version ? null,
}:

with lib;
(mkCoqDerivation {
  pname = "parseque";
  repo = "parseque";
  owner = "rocq-community";

  inherit version;
  defaultVersion =
    with versions;
    switch
      [ coq.coq-version ]
      [
        {
          cases = [ (range "8.16" "9.0") ];
          out = "0.3.0";
        }
      ]
      null;

  release."0.3.0".sha256 = "sha256-W2eenv5Q421eVn2ubbninFmmdT875f3w/Zs7yGHUKP4=";

  releaseRev = v: "v${v}";

  meta = {
    description = "Total parser combinators in Coq/Rocq";
    maintainers = with maintainers; [ womeier ];
    license = licenses.mit;
  };
}).overrideAttrs
  (
    o:
    # this is just a wrapper for rocPackages.parseque for Rocq >= 9.0
    lib.optionalAttrs
      (coq.version != null && (coq.version == "dev" || lib.versions.isGe "9.0" coq.version))
      {
        configurePhase = ''
          echo no configuration
        '';
        buildPhase = ''
          echo building nothing
        '';
        installPhase = ''
          echo installing nothing
        '';
        propagatedBuildInputs = [ rocqPackages.parseque ];
      }
  )
