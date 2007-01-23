{ stdenv, fetchurl, ocaml, perl }:

stdenv.mkDerivation {
  name    = "cil-aterm-1.3.4";
  src     = fetchurl {
		url = http://surfnet.dl.sourceforge.net/sourceforge/cil/cil-1.3.4.tar.gz;
                md5 = "a7fa54f19844a20562efd37f67c391da";
            };
  patches = [./cil-aterm-1.3.4.patch];
  buildInputs = [ ocaml perl ];
  inherit ocaml perl;
}  
