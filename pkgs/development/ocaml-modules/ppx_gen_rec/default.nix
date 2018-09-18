{ stdenv, fetchurl, ocaml, findlib, dune, ocaml-migrate-parsetree }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  pname = "ppx_gen_rec";
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "0qy0wa3rd5yh1612jijadi1yddfslpsmmmf69phi2dhr3vmkhza7";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib dune ocaml-migrate-parsetree ];

  buildPhase = "dune build -p ppx_gen_rec";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-ppx_gen_rec;
    description = "ocaml preprocessor that generates a recursive module";
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.frontsideair ];
  };
}
