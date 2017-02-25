{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam
, topkg, result, lwt, cmdliner, fmt }:
let
  pname = "logs";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "0.6.2";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1khbn7jqpid83zn8rvyh1x1sirls7zc878zj4fz985m5xlsfy853";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild opam topkg fmt cmdliner lwt ];
  propagatedBuildInputs = [ result ];

  buildPhase = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml build \
      --with-js_of_ocaml false
    '';

  inherit (topkg) installPhase;

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "Logging infrastructure for OCaml";
    homepage = "${webpage}";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
