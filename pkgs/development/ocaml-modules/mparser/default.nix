{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-mparser-1.2.3";
  src = fetchzip {
    url = "https://github.com/cakeplus/mparser/archive/1.2.3.tar.gz";
    sha256 = "1f8vpagmv0jdm50pxs2xwh2xcmvgaprx4kw871hlml9ahsflxgnw";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = ''
    runHook preConfigure
    ocaml setup.ml -configure
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    ocaml setup.ml -build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$OCAMLFIND_DESTDIR"
    ocaml setup.ml -install
    runHook postInstall
  '';

  meta = {
    description = "A simple monadic parser combinator OCaml library";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/cakeplus/mparser";
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
