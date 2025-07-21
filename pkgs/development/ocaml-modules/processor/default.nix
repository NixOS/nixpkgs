{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "processor";
  version = "0.1-unstable-2024-07-23";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "haesbaert";
    repo = "ocaml-processor";
    rev = "74df5ab38773e5c4ad5c3a3f21f525d863731c17";
    hash = "sha256-tWmgAsYfcpZUyxo7F+WIC3WOfAjDiuV74CscqEd93gk=";
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
