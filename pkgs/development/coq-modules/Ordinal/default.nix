{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
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
        case = range "8.12" "9.2";
        out = "0.5.6";
      }
    ] null;
  release = {
    "0.5.6".sha256 = "sha256-ox9GaUsh/tWJGEPawPnNqXULI0kYglKmNmiTL8dF3uU=";
    "0.5.5".sha256 = "sha256-Z7+alcN63hxJOtBAXPg9ExNdwS2SiB63ZjDEnPhGi6g=";
    "0.5.4".sha256 = "sha256-PaEC71FzJzHVGYpf3J1jvb/JsJzzMio0L5d5dPwiXuc=";
    "0.5.3".sha256 = "sha256-Myxwy749ZCBpqia6bf91cMTyJn0nRzXskD7Ue8kc37c=";
    "0.5.2".sha256 = "sha256-jf16EyLAnKm+42K+gTTHVFJqeOVQfIY2ozbxIs5x5DE=";
    "0.5.1".sha256 = "sha256-ThJ+jXmtkAd3jElpQZqfzqqc3EfoKY0eMpTHnbrracY=";
    "0.5.0".sha256 = "sha256-Jq0LnR7TgRVcPqh8Ha6tIIK3KfRUgmzA9EhxeySgPnM=";
  };
  releaseRev = v: "v${v}";
  propagatedBuildInputs = [ stdlib ];
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
