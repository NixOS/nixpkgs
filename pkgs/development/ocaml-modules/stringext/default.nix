{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ounit, qcheck
# Optionally enable tests; test script use OCaml-4.01+ features
, doCheck ? stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01"
}:

let version = "1.4.3"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-stringext-${version}";

  src = fetchzip {
    url = "https://github.com/rgrinberg/stringext/archive/v${version}.tar.gz";
    sha256 = "121k79vjazvsd254yg391fp4spsd1p32amccrahd0g6hjhf5w6sl";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit qcheck ];

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
