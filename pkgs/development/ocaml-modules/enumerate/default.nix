{ stdenv, fetchurl, ocaml, findlib, type_conv, camlp4 }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

stdenv.mkDerivation {
  name = "ocaml-enumerate-111.08.00";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/111.08.00/individual/enumerate-111.08.00.tar.gz;
    sha256 = "0b6mx5p01lcpimvak4wx6aj2119707wsfzd83rwgb91bhpgzh156";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ type_conv camlp4 ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://ocaml.janestreet.com/;
    description = "Quotation expanders for enumerating finite types";
    license = stdenv.lib.licenses.asl20;
    platforms = ocaml.meta.platforms or [];
  };
}
