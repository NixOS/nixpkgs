{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ocaml-3.08.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://caml.inria.fr/distrib/ocaml-3.08/ocaml-3.08.0.tar.gz;
    md5 = "c6ef478362295c150101cdd2efcd38e0";
  }
}
