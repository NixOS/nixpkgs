{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg }:
let
  pname = "xmlm";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.3.0";
    sha256 = "1rrdxg5kh9zaqmgapy9bhdqyxbbvxxib3bdfg1vhw4rrkp1z0x8n";
    buildInputs = [ topkg ];
    inherit (topkg) buildPhase;
  } else {
    version = "1.2.0";
    sha256 = "1jywcrwn5z3gkgvicr004cxmdaqfmq8wh72f81jqz56iyn5024nh";
    buildInputs = [];
    buildPhase = "./pkg/build true";
  };
in

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  inherit (param) version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ] ++ param.buildInputs;

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (param) buildPhase;

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
