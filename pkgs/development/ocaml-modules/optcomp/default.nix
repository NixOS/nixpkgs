{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-optcomp";
  src = fetchurl {
    url = https://github.com/diml/optcomp/archive/1.6.tar.gz;
    md5 = "d3587244dba1b8b10f24d0b60a8c700d";
    };
  
  createFindlibDestdir = true;

  buildInputs = [ocaml findlib];


  meta =  {
    homepage = https://github.com/diml/optcomp;
    description = "Optional compilation for OCaml with cpp-like directives";
    license = "BSD";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };

}
