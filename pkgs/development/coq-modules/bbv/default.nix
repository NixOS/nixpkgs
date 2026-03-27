{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "bbv";
  owner = "mit-plv";
  inherit version;
  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.16" "8.19";
        out = "1.5";
      }
    ] null;
  release = {
    "1.5".sha256 = "sha256-8/VPsfhNpuYpLmLC/hWszDhgvS6n8m7BRxUlea8PSUw=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ stdlib ];

  meta = {
    description = "Implementation of bitvectors in Coq";
    license = lib.licenses.mit;
  };
}
