{ lib, buildDunePackage
, pbrt
, stdlib-shims
}:

buildDunePackage rec {
  pname = "ocaml-protoc";

  inherit (pbrt) version src;

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ pbrt ];

  doCheck = true;

  meta = pbrt.meta // {
    description = "A Protobuf Compiler for OCaml";
  };
}
