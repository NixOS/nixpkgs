{ stdenv, fetchzip, ocaml, findlib, re, sexplib, stringext, ounit }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

let version = "1.9.1"; in

stdenv.mkDerivation {
  name = "ocaml-uri-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-uri/archive/v${version}.tar.gz";
    sha256 = "0v3jxqgyi4kj92r3x83rszfpnvvzy9lyb913basch4q64yka3w85";
  };

  buildInputs = [ ocaml findlib ounit ];
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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
