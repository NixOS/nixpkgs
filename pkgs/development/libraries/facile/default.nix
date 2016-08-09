{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "facile-1.1";
  
  src = fetchurl {
    url = "${meta.homepage}/distrib/${name}.tar.gz";
    sha256 = "1jp59ankjds8mh4vm0b5h4fd1lcbfn0rd6n151cgh14ihsknnym8";
  };
  
  dontAddPrefix = 1;

  patches = [ ./ocaml_4.xx.patch ];

  postPatch = "sed -e 's@mkdir@mkdir -p@' -i Makefile";

  postConfigure = "make -C src .depend";
  
  makeFlags = "FACILEDIR=\${out}/lib/ocaml/facile";
  
  buildInputs = [ ocaml ];

  meta = {
    homepage = http://www.recherche.enac.fr/log/facile;
    license = "LGPL";
    description = "A Functional Constraint Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
