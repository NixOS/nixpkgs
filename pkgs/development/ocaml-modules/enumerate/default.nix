{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, type_conv, camlp4 }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.00";

if lib.versionAtLeast ocaml.version "4.06"
then throw "enumerate-111.08.00 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml-enumerate";
  version = "111.08.00";

  src = fetchurl {
    url = "https://ocaml.janestreet.com/ocaml-core/${lib.versions.majorMinor version}.00/individual/enumerate-${version}.tar.gz";
    sha256 = "0b6mx5p01lcpimvak4wx6aj2119707wsfzd83rwgb91bhpgzh156";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ type_conv camlp4 ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "https://ocaml.janestreet.com/";
    description = "Quotation expanders for enumerating finite types";
    license = lib.licenses.asl20;
    platforms = ocaml.meta.platforms or [ ];
  };
}
