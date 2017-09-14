{stdenv, fetchurl, ocaml, findlib, gmp, mpfr, ncurses }:

if stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "mlgmp is not available for OCaml ${ocaml.version}" else

let
  pname = "mlgmp";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "20120224";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/~monniaux/download/${pname}_${version}.tar.gz";
    sha256 = "3ce1a53fa452ff5a9ba618864d3bc46ef32190b57202d1e996ca7df837ad4f24";
  };

  makeFlags = [ 
    "DESTDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/gmp"
  ];

  preConfigure = "make clean";
  buildInputs = [ocaml findlib gmp mpfr ncurses];

  createFindlibDestdir = true;

  propagatedbuildInputs = [gmp mpfr ncurses];

  postInstall  = ''
     cp ${./META} $out/lib/ocaml/${ocaml.version}/site-lib/gmp/META
  '';

  meta = {
    homepage = http://opam.ocamlpro.com/pkg/mlgmp.20120224.html;
    description = "OCaml bindings to GNU MP library";
    license = "Free software ?";
  };
}
