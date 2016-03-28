{stdenv, fetchurl, ocaml, findlib, opam}:
let
  pname = "uutf";
  version = "0.9.3";
  webpage = "http://erratique.ch/software/${pname}";
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0xvq20knmq25902ijpbk91ax92bkymsqkbfklj1537hpn64lydhz";
  };

  buildInputs = [ ocaml findlib opam ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "./pkg/build true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml_version}/site-lib/
  '';

  meta = with stdenv.lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
