{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

let version = "2.0.0"; in

stdenv.mkDerivation {
  name = "ocaml-base64-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-base64/archive/v${version}.tar.gz";
    sha256 = "1nv55gwq5vaxmrcz9ja2s165b1p9fhcxszc1l76043gpa56qm4fs";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/ocaml-base64;
    platforms = ocaml.meta.platforms or [];
    description = "Base64 encoding and decoding in OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
