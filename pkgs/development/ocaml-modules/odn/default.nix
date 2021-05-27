{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, type_conv, ounit, camlp4 }:

if lib.versionAtLeast ocaml.version "4.06"
then throw "ocaml-data-notation is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml-data-notation-0.0.11";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1310/ocaml-data-notation-0.0.11.tar.gz";
    sha256 = "09a8zdyifpc2nl4hdvg9206142y31cq95ajgij011s1qcg3z93lj";
  };

  buildInputs = [ ocaml findlib ocamlbuild type_conv ounit camlp4 ];

  createFindlibDestdir = true;

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
    ocaml setup.ml -install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Store data using OCaml notation";
    homepage = "https://forge.ocamlcore.org/projects/odn/";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      vbgl maggesi
    ];
  };
}
