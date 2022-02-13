{ lib, fetchurl, buildDunePackage, cppo, ppx_deriving
, ppxlib
}:

buildDunePackage rec {
  pname = "ppx_deriving_protobuf";
  version = "3.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_deriving_protobuf/releases/download/v${version}/ppx_deriving_protobuf-v${version}.tbz";
    sha256 = "1dc1vxnkd0cnrgac5v3zbaj2lq1d2w8118mp1cmsdxylp06yz1sj";
  };

  buildInputs = [ cppo ppxlib ppx_deriving ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-ppx/ppx_deriving_protobuf";
    description = "A Protocol Buffers codec generator for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
