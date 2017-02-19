{ stdenv, fetchzip, ocaml, findlib, re, stringext, ounit
, sexplib, ppx_sexp_conv
, legacyVersion ? false
, sexplib_p4
}:

assert stdenv.lib.versionAtLeast ocaml.version "4";

with
  if legacyVersion
  then {
    version = "1.9.1";
    sha256 = "0v3jxqgyi4kj92r3x83rszfpnvvzy9lyb913basch4q64yka3w85";
  } else {
    version = "1.9.2";
    sha256 = "137pg8j654x7r0d1664iy2zp3l82nki1kkh921lwdrwc5qqdl6jx";
  };

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-uri-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-uri/archive/v${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ ocaml findlib ounit ]
  ++ stdenv.lib.optional (!legacyVersion) ppx_sexp_conv;
  propagatedBuildInputs = [ re (if legacyVersion then sexplib_p4 else sexplib) stringext ];

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
