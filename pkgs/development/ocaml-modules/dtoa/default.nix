{ stdenv, fetchurl, ocaml, findlib, dune }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  pname = "dtoa";
  name = "ocaml-${pname}-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "0rzysj07z2q6gk0yhjxnjnba01vmdb9x32wwna10qk3rrb8r2pnn";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib dune ];

  buildPhase = "dune build -p dtoa";

  inherit (dune) installPhase;

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-dtoa;
    description = "Converts OCaml floats into strings (doubles to ascii, \"d to a\"), using the efficient Grisu3 algorithm.";
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.eqyiel ];
  };
}
