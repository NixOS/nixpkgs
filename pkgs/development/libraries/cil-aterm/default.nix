{ stdenv, fetchurl, ocaml, perl }:

stdenv.mkDerivation {
  name    = "cil-aterm-1.3.3";
  src     = fetchurl {
		url = http://manju.cs.berkeley.edu/cil/distrib/cil-1.3.3.tar.gz;
                md5 = "dafd350c154990728efb35a7073ca81a";
            };
  patches = [./atermprinter.patch];
  buildInputs = [ ocaml perl ];
  inherit ocaml perl;
}  
