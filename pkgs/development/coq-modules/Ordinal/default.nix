{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:
mkCoqDerivation {
  pname = "Ordinal";
  owner = "snu-sf";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.12" "8.18";
        out = "0.5.3";
      }
    ] null;
  release = {
    "0.5.3".sha256 = "sha256-Myxwy749ZCBpqia6bf91cMTyJn0nRzXskD7Ue8kc37c=";
    "0.5.2".sha256 = "sha256-jf16EyLAnKm+42K+gTTHVFJqeOVQfIY2ozbxIs5x5DE=";
    "0.5.1".sha256 = "sha256-ThJ+jXmtkAd3jElpQZqfzqqc3EfoKY0eMpTHnbrracY=";
    "0.5.0".sha256 = "sha256-Jq0LnR7TgRVcPqh8Ha6tIIK3KfRUgmzA9EhxeySgPnM=";
  };
  releaseRev = v: "v${v}";
  installPhase = ''
    make -f Makefile.coq COQMF_COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';
  meta = {
    homepage = "https://github.com/snu-sf/Ordinal";
    description = "Ordinal Numbers in Coq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ damhiya ];
  };
}
