{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, camlp4 }:

stdenv.mkDerivation {
  name = "ocaml-optcomp-1.6";
  src = fetchurl {
    url = https://github.com/diml/optcomp/archive/1.6.tar.gz;
    sha256 = "0hhhb2gisah1h22zlg5iszbgqxdd7x85cwd57bd4mfkx9l7dh8jh";
  };
  
  createFindlibDestdir = true;

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];


  meta =  {
    homepage = https://github.com/diml/optcomp;
    description = "Optional compilation for OCaml with cpp-like directives";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };

}
