{stdenv, fetchurl, ocaml, findlib, gmp, mpfr, ncurses }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "mlgmp";
  version = "20120224";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/~monniaux/download/${pname}_${version}.tar.gz";
    sha256 = "3ce1a53fa452ff5a9ba618864d3bc46ef32190b57202d1e996ca7df837ad4f24";
  };

  makeFlags = [ 
    "DESTDIR=$(out)/lib/ocaml/${ocaml_version}/site-lib/gmp"
  ];

  preConfigure = "make clean";
  buildInputs = [ocaml findlib gmp mpfr ncurses];

  createFindlibDestdir = true;

  propagatedbuildInputs = [gmp mpfr ncurses];

  postInstall  = ''
     cp ${./META} $out/lib/ocaml/${ocaml_version}/site-lib/gmp/META
  '';

  meta = {
    homepage = http://opam.ocamlpro.com/pkg/mlgmp.20120224.html;
    description = "OCaml bindings to GNU MP library";
    license = "Free software ?";
  };
}
