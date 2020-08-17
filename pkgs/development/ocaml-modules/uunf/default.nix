{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner }:
let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.03";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "13.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1qci04nkp24kdls1z4s8kz5dzgky4nwd5r8345nwdrgwmxhw7ksm";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf cmdliner ];

  propagatedBuildInputs = [ uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    broken = stdenv.isAarch64;
  };
}
