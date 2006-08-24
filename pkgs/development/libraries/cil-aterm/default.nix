{ stdenv, fetchurl, ocaml3080, perl }:

stdenv.mkDerivation {
  name    = "cil-aterm-1.3.4";
  src     = fetchurl {
		url = http://manju.cs.berkeley.edu/cil/distrib/cil-1.3.4.tar.gz;
                md5 = "a7fa54f19844a20562efd37f67c391da";
            };
  patches = [./cil-aterm-1.3.4.patch];
  buildInputs = [ ocaml3080 perl ];
  inherit ocaml perl;
}  
