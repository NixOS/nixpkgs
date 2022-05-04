{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, dune_2, benchmark }:

let param =
  if lib.versionAtLeast ocaml.version "4.03"
  then rec {
    version = "0.6.2";
    url = "https://github.com/Chris00/ocaml-rope/releases/download/${version}/rope-${version}.tbz";
    sha256 = "15cvfa0s1vjx7gjd07d3fkznilishqf4z4h2q5f20wm9ysjh2h2i";
    nativeBuildInputs = [ dune_2 ];
    extra = {
      buildPhase = "dune build -p rope";
      installPhase = ''
        dune install --prefix $out --libdir $OCAMLFIND_DESTDIR rope
      '';
    };
  } else {
    version = "0.5";
    url = "https://forge.ocamlcore.org/frs/download.php/1156/rope-0.5.tar.gz";
    sha256 = "05fr2f5ch2rqhyaj06rv5218sbg99p1m9pq5sklk04hpslxig21f";
    nativeBuildInputs = [ ocamlbuild ];
    extra = { createFindlibDestdir = true; };
  };
in

stdenv.mkDerivation ({
  pname = "ocaml${ocaml.version}-rope";
  inherit (param) version;

  src = fetchurl {
    inherit (param) url sha256;
  };

  nativeBuildInputs = [ ocaml findlib ] ++ param.nativeBuildInputs;
  buildInputs = [ benchmark ] ;

  strictDeps = true;

  meta = {
    homepage = "http://rope.forge.ocamlcore.org/";
    platforms = ocaml.meta.platforms or [];
    description = ''Ropes ("heavyweight strings") in OCaml'';
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ volth ];
  };
} // param.extra)
