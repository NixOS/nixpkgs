{ stdenv, fetchzip, ocaml, findlib, oasis, ocaml_optcomp, camlp4 }:

let version = "0.7"; in

stdenv.mkDerivation {
  name = "ocsigen-deriving-${version}";
  src = fetchzip {
    url = "https://github.com/ocsigen/deriving/archive/${version}.tar.gz";
    sha256 = "05z606gly1iyan292x3mflg3zasgg68n8i2mivz0zbshx2hz2jbw";
    };

  buildInputs = [ ocaml findlib oasis ocaml_optcomp camlp4 ];

  createFindlibDestdir = true;

  meta =  {
    homepage = https://github.com/ocsigen/deriving;
    description = "Extension to OCaml for deriving functions from type declarations";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with stdenv.lib.maintainers; [
      gal_bolle vbgl
    ];
  };


}
