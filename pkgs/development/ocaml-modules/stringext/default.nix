{ stdenv, fetchzip, ocaml, findlib, ounit, qcheck
# Optionally enable tests; test script use OCaml-4.01+ features
, doCheck ? stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01"
}:

let version = "1.4.0"; in

stdenv.mkDerivation {
  name = "ocaml-stringext-${version}";

  src = fetchzip {
    url = "https://github.com/rgrinberg/stringext/archive/v${version}.tar.gz";
    sha256 = "1jp0x9rkss8a48z9wbnc4v5zvmnysin30345psl3xnxb2aqzwlii";
  };

  buildInputs = [ ocaml findlib ounit qcheck ];

  configurePhase = "ocaml setup.ml -configure --prefix $out"
  + stdenv.lib.optionalString doCheck " --enable-tests";
  buildPhase = "ocaml setup.ml -build";
  inherit doCheck;
  checkPhase = "ocaml setup.ml -test";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/rgrinberg/stringext;
    platforms = ocaml.meta.platforms or [];
    description = "Extra string functions for OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
