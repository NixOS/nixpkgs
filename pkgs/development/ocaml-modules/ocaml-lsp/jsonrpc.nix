{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, yojson
, result
, fetchzip
, lib
}:


buildDunePackage rec {
  pname = "jsonrpc";
  version = "1.4.1";
  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/jsonrpc-${version}.tbz";
    sha256 = "0hzpw17qfhb0cxgwah1fv4k300r363dy1kv0977anl44dlanx1v5";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.06";

  buildInputs = [ yojson stdlib-shims ocaml-syntax-shims ppx_yojson_conv_lib result ];

  meta = with lib; {
    description = "Jsonrpc protocol implementation in OCaml";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ symphorien marsam ];
  };
}
