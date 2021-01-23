{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "3.2.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchurl {
    url = "https://github.com/ocaml-batteries-team/batteries-included/releases/download/v${version}/batteries-${version}.tar.gz";
    sha256 = "0a77njgc6c6kz4rpwqgmnii7f1na6hzsa55nqqm3dndhq9xh628w";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  checkInputs = [ qtest ];
  propagatedBuildInputs = [ num ];

  doCheck = lib.versionAtLeast ocaml.version "4.04" && !stdenv.isAarch64;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = "http://batteries.forge.ocamlcore.org/";
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
