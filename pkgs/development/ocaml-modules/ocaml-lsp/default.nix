{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, yojson
, result
, omd
, octavius
, dune-build-info
, uutf
, csexp
, cmdliner
, fetchzip
, lib
}:
let
  version = "1.4.1";
  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/jsonrpc-${version}.tbz";
    sha256 = "0hzpw17qfhb0cxgwah1fv4k300r363dy1kv0977anl44dlanx1v5";
  };

  # unvendor some (not all) dependencies.
  # They are vendored by upstream only because it is then easier to install
  # ocaml-lsp without messing with your opam switch, but nix should prevent
  # this type of problems without resorting to vendoring.
  preBuild = ''
    rm -r ocaml-lsp-server/vendor/{octavius,uutf,ocaml-syntax-shims,omd,cmdliner}
  '';

  buildInputs = [
    stdlib-shims
    ppx_yojson_conv_lib
    ocaml-syntax-shims
    octavius
    uutf
    csexp
    dune-build-info
    omd
    cmdliner
    jsonrpc
  ];

  lsp = buildDunePackage {
    pname = "lsp";
    inherit version src;
    useDune2 = true;
    minimumOCamlVersion = "4.06";

    inherit buildInputs preBuild;
  };

  jsonrpc = buildDunePackage {
    pname = "jsonrpc";
    inherit version src;
    useDune2 = true;
    minimumOCamlVersion = "4.06";

    buildInputs = [ yojson stdlib-shims ocaml-syntax-shims ppx_yojson_conv_lib result ];
  };

in
buildDunePackage {
  pname = "ocaml-lsp-server";
  inherit version src;
  useDune2 = true;

  inherit preBuild;

  buildInputs = buildInputs ++ [ lsp ];

  meta = with lib; {
    description = "OCaml Language Server Protocol implementation";
    license = lib.licenses.isc;
    platforms = platforms.unix;
    maintainers = [ maintainers.symphorien maintainers.marsam ];
  };
}
