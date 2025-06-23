{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "processor";
  version = "0.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "haesbaert";
    repo = "ocaml-processor";
    tag = "v${version}";
    hash = "sha256-eGSNYjVbUIUMelajqZYOd3gvmRKQ9UP3TfMflLR9i7k=";
  };

  doCheck = true;

  meta = {
    description = "CPU topology and affinity for ocaml-multicore";
    homepage = "https://haesbaert.github.io/ocaml-processor/processor/index.html";
    downloadPage = "https://github.com/haesbaert/ocaml-processor";
    changelog = "https://github.com/haesbaert/ocaml-processor/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
