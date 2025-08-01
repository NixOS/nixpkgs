{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
}:

let
  param =
    if lib.versionAtLeast ocaml.version "4.02" then
      {
        version = "0.6";
        sha256 = "18wpyxblz9jh5bfp0hpffnd0q8cq1b0dqp0f36vhqydfknlnpx8y";
      }
    else
      {
        version = "0.5";
        sha256 = "1j17rhifdjv1z262dma148ywg34x0zjn8vczdrnkwajsm4qg1hw3";
      };
in

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "functory is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  {
    pname = "ocaml${ocaml.version}-functory";
    inherit (param) version;

    src = fetchurl {
      url = "https://www.lri.fr/~filliatr/functory/download/functory-${param.version}.tar.gz";
      inherit (param) sha256;
    };

    nativeBuildInputs = [
      ocaml
      findlib
    ];

    strictDeps = true;

    installTargets = [ "ocamlfind-install" ];

    createFindlibDestdir = true;

    meta = with lib; {
      homepage = "https://www.lri.fr/~filliatr/functory/";
      description = "Distributed computing library for Objective Caml which facilitates distributed execution of parallelizable computations in a seamless fashion";
      license = licenses.lgpl21;
      maintainers = [ maintainers.vbgl ];
      inherit (ocaml.meta) platforms;
    };
  }
