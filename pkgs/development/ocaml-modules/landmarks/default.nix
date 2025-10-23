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

  meta = {
    inherit (src.meta) homepage;
    description = "Simple Profiling Library for OCaml";
    longDescription = ''
      Landmarks is a simple profiling library for OCaml. It provides
      primitives to measure time spent in portion of instrumented code. The
      instrumentation of the code may either done by hand, automatically or
      semi-automatically using the ppx pepreprocessor (see landmarks-ppx package).
    '';
    changelog = "https://raw.githubusercontent.com/LexiFi/landmarks/refs/tags/v${version}/CHANGES.md";
    maintainers = with lib.maintainers; [ kenran ];
    license = lib.licenses.mit;
  };
}
