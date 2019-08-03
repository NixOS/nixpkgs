{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, dune, benchmark }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.03"
  then {
    version = "0.6.1";
    url = " https://github.com/Chris00/ocaml-rope/releases/download/0.6.1/rope-0.6.1.tbz";
    sha256 = "1zqh28jz1zjb0l354wi1046qpkwmk582ssz0gsqh6d44wpspdxk2";
    buildInputs = [ dune ];
    extra = {
      buildPhase = "dune build -p rope";
      inherit (dune) installPhase;
    };
  } else {
    version = "0.5";
    url = "https://forge.ocamlcore.org/frs/download.php/1156/rope-0.5.tar.gz";
    sha256 = "05fr2f5ch2rqhyaj06rv5218sbg99p1m9pq5sklk04hpslxig21f";
    buildInputs = [ ocamlbuild ];
    extra = { createFindlibDestdir = true; };
  };
in

stdenv.mkDerivation ({
  name = "ocaml${ocaml.version}-rope-${param.version}";

  src = fetchurl {
    inherit (param) url sha256;
  };

  buildInputs = [ ocaml findlib benchmark ] ++ param.buildInputs;

  meta = {
    homepage = http://rope.forge.ocamlcore.org/;
    platforms = ocaml.meta.platforms or [];
    description = ''Ropes ("heavyweight strings") in OCaml'';
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
} // param.extra)
