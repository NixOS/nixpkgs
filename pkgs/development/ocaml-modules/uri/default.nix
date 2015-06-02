{ stdenv, fetchzip, ocaml, findlib, re, sexplib, stringext }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

let version = "1.9.0"; in

stdenv.mkDerivation {
  name = "ocaml-uri-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-uri/archive/v${version}.tar.gz";
    sha256 = "13vbv6q7npl2bvvqfw03mav90jcrrvjbdpdp4y8mcjz0iax5ww9b";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ re sexplib stringext ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = ''
    ocaml setup.ml -build
    ocaml setup.ml -doc
  '';
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/ocaml-uri;
    platforms = ocaml.meta.platforms;
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
