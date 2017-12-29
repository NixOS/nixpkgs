{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ctypes, result, SDL2, pkgconfig, opam, ocb-stubblr }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "tsdl is not available for OCaml ${ocaml.version}"
else

let
  pname = "tsdl";
  version = "0.9.4";
  webpage = "http://erratique.ch/software/${pname}";
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "13af37w2wybx8yzgjr5zz5l50402ldl614qiwphl1q69hig5mag2";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg result pkgconfig opam ocb-stubblr ];
  propagatedBuildInputs = [ SDL2 ctypes ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  preConfigure = ''
    # The following is done to avoid an additional dependency (ncurses)
    # due to linking in the custom bytecode runtime. Instead, just
    # compile directly into a native binary, even if it's just a
    # temporary build product.
    substituteInPlace myocamlbuild.ml \
      --replace ".byte" ".native"
  '';

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    homepage = "${webpage}";
    description = "Thin bindings to the cross-platform SDL library";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
