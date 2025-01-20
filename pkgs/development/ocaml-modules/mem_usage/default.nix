{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "mem_usage";
  version = "0.1.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-mem_usage";
    tag = "v${version}";
    hash = "sha256-Ig0MZdCt0JTcCxp15E69K2SsoPd7cKr5XocTo25CCzs=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-mem_usage";
    description = "Crossplatform library to get memory usage information";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
