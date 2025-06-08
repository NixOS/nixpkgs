{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
}:

buildDunePackage rec {
  pname = "landmarks";
  version = "1.5";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LexiFi";
    repo = "landmarks";
    tag = "v${version}";
    hash = "sha256-eIq02D19OzDOrMDHE1Ecrgk+T6s9vj2X6B2HY+z+K8Q=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08" && lib.versionOlder ocaml.version "5.0";

  meta = with lib; {
    description = "Simple Profiling Library for OCaml";
    maintainers = [ maintainers.kenran ];
    license = licenses.mit;
  };
}
