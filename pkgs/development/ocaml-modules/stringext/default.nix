{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild, ounit, qcheck
# Optionally enable tests; test script use OCaml-4.01+ features
, doCheck ? lib.versionAtLeast (lib.getVersion ocaml) "4.01"
}:

let version = "1.4.3"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-stringext-${version}";

  src = fetchzip {
    url = "https://github.com/rgrinberg/stringext/archive/v${version}.tar.gz";
    sha256 = "121k79vjazvsd254yg391fp4spsd1p32amccrahd0g6hjhf5w6sl";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit qcheck ];

  configurePhase = ''
    runHook preConfigure
    ocaml setup.ml -configure --prefix $out ${lib.optionalString doCheck "--enable-tests"}
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    ocaml setup.ml -build
    runHook postBuild
  '';
  inherit doCheck;
  checkPhase = ''
    runHook preCheck
    ocaml setup.ml -test
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$OCAMLFIND_DESTDIR"
    ocaml setup.ml -install
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rgrinberg/stringext";
    platforms = ocaml.meta.platforms or [];
    description = "Extra string functions for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
