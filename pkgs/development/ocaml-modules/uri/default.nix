{ stdenv, fetchzip, ocaml, findlib, re, sexplib, stringext, ounit, ppx_sexp_conv }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

let version = "1.9.2"; in

stdenv.mkDerivation {
  name = "ocaml-uri-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-uri/archive/v${version}.tar.gz";
    sha256 = "137pg8j654x7r0d1664iy2zp3l82nki1kkh921lwdrwc5qqdl6jx";
  };

  buildInputs = [ ocaml findlib ounit ppx_sexp_conv ];
  propagatedBuildInputs = [ re sexplib stringext ];

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";
  buildPhase = ''
    ocaml setup.ml -build
    ocaml setup.ml -doc
  '';
  doCheck = true;
  checkPhase = "ocaml setup.ml -test";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/ocaml-uri;
    platforms = ocaml.meta.platforms or [];
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
