{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "3.0.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchurl {
    url = "https://github.com/ocaml-batteries-team/batteries-included/releases/download/v${version}/batteries-${version}.tar.gz";
    sha256 = "0d833amm4p0pczgl7wriv99f3r5r6345p5gi9d97sm0hqx27vzwi";
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
