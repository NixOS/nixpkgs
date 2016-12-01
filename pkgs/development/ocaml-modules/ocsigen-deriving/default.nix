{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, oasis, ocaml_optcomp, camlp4 }:

let version = "0.7.1"; in

stdenv.mkDerivation {
  name = "ocsigen-deriving-${version}";
  src = fetchzip {
    url = "https://github.com/ocsigen/deriving/archive/${version}.tar.gz";
    sha256 = "0gg3nr3iic4rwqrcc0qvfm9x0x57zclvdsnpy0z8rv2fl5isbzms";
    };

  buildInputs = [ ocaml findlib ocamlbuild oasis ocaml_optcomp camlp4 ];

  createFindlibDestdir = true;

  meta =  {
    homepage = https://github.com/ocsigen/deriving;
    description = "Extension to OCaml for deriving functions from type declarations";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [
      gal_bolle vbgl
    ];
  };


}
