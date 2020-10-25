{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
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
  version = "1.1.0";
  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/ocaml-lsp-server-${version}.tbz";
    sha256 = "0al89waw43jl80k9z06kh44byhjhwb5hmzx07sddwi1kr1vc6jrb";
  };

  # unvendor some (not all) dependencies.
  # They are vendored by upstream only because it is then easier to install
  # ocaml-lsp without messing with your opam switch, but nix should prevent
  # this type of problems without resorting to vendoring.
  preBuild = ''
    rm -r vendor/{octavius,uutf,ocaml-syntax-shims,omd,cmdliner}
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
  ];

  lsp = buildDunePackage {
    pname = "lsp";
    inherit version src;
    useDune2 = true;
    minimumOCamlVersion = "4.06";

    inherit buildInputs preBuild;
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
    maintainers = [ maintainers.symphorien ];
  };
}
