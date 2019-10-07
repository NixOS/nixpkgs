{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "2.10.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchurl {
    url = "https://github.com/ocaml-batteries-team/batteries-included/releases/download/v${version}/batteries-${version}.tar.gz";
    sha256 = "08ghw87d56h1a6y1nnh3x2wy9xj25jqfk5sp6ma9nsyd37babb0h";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ];
  propagatedBuildInputs = [ num ];

  doCheck = stdenv.lib.versions.majorMinor ocaml.version != "4.07" && !stdenv.isAarch64;
  checkTarget = "test test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://batteries.forge.ocamlcore.org/;
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
