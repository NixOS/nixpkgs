{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "2.9.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "1wianim29kkkf4c31k7injjp3ji69ki5krrp6csq8ycswg791dby";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ];
  propagatedBuildInputs = [ num ];

  doCheck = !stdenv.lib.versionAtLeast ocaml.version "4.07" && !stdenv.isAarch64;
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
      stdenv.lib.maintainers.z77z
    ];
  };
}
