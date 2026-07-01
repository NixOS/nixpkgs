{
  lib,
  ocaml,
  buildDunePackage,
  pbrt,
  stdlib-shims,
  pbrt_services,
}:

buildDunePackage {
  pname = "ocaml-protoc";

  inherit (pbrt) version src;

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ pbrt ];

  doCheck = lib.versionAtLeast ocaml.version "5.1";
  checkInputs = [ pbrt_services ];

  meta = pbrt.meta // {
    description = "Protobuf Compiler for OCaml";
  };
}
