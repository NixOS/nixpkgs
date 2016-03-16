{stdenv, fetchurl, ocaml, findlib, camlp4}:

stdenv.mkDerivation {
  name = "ocaml-optcomp-1.6";
  src = fetchurl {
    url = https://github.com/diml/optcomp/archive/1.6.tar.gz;
    md5 = "d3587244dba1b8b10f24d0b60a8c700d";
    };
  
  createFindlibDestdir = true;

  buildInputs = [ocaml findlib camlp4];


  meta =  {
    homepage = https://github.com/diml/optcomp;
    description = "Optional compilation for OCaml with cpp-like directives";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };

}
