{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild, oasis, ocaml_optcomp, camlp4
, num
}:

let param =
  if lib.versionAtLeast ocaml.version "4.03"
  then {
    version = "0.8.1";
    sha256 = "03vzrybdpjydbpil97zmir71kpsn2yxkjnzysma7fvybk8ll4zh9";
    buildInputs = [ num ];
  } else {
    version = "0.7.1";
    sha256 = "0gg3nr3iic4rwqrcc0qvfm9x0x57zclvdsnpy0z8rv2fl5isbzms";
  };
in

let inherit (param) version; in

stdenv.mkDerivation {
  pname = "ocsigen-deriving";
  inherit version;
  src = fetchzip {
    url = "https://github.com/ocsigen/deriving/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild oasis ocaml_optcomp camlp4 ]
  ++ (param.buildInputs or []);

  createFindlibDestdir = true;

  meta =  {
    homepage = "https://github.com/ocsigen/deriving";
    description = "Extension to OCaml for deriving functions from type declarations";
    license = lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with lib.maintainers; [
      gal_bolle vbgl
    ];
  };


}
