{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, qtest, num
, doCheck ? lib.versionAtLeast ocaml.version "4.08" && !stdenv.isAarch64
}:

let version = "3.3.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchurl {
    url = "https://github.com/ocaml-batteries-team/batteries-included/releases/download/v${version}/batteries-${version}.tar.gz";
    sha256 = "002pqkcg18zx59hsf172wg6s7lwsiagp5sfvf5yssp7xxal5jdgx";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  checkInputs = [ qtest ];
  propagatedBuildInputs = [ num ];

  inherit doCheck;
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
