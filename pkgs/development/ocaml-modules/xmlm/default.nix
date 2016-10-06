{stdenv, fetchurl, ocaml, findlib, opam}:
let
  pname = "xmlm";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1jywcrwn5z3gkgvicr004cxmdaqfmq8wh72f81jqz56iyn5024nh";
  };

  buildInputs = [ ocaml findlib opam ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "./pkg/build true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = with stdenv.lib; {
    description = "An OCaml streaming codec to decode and encode the XML data format";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
