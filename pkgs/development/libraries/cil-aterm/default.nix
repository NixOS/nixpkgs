{ stdenv, fetchurl, ocaml, perl }:

stdenv.mkDerivation {
  name    = "cil-aterm-1.3.6";
  src     = fetchurl {
		url = mirror://sourceforge/cil/cil-1.3.6.tar.gz;
                md5 = "112dfbabdd0e1280800d62ba4449ab45";
            };
  patches = [./cil-aterm-1.3.6.patch];
  buildInputs = [ ocaml perl ];
  inherit ocaml perl;
  meta.broken = true;
}  
