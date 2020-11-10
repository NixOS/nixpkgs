{ stdenv, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "3.1.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchurl {
    url = "https://github.com/ocaml-batteries-team/batteries-included/releases/download/v${version}/batteries-${version}.tar.gz";
    sha256 = "0bq1np3ai3r559s3vivn45yid25fwz76rvbmsg30j57j7cyr3jqm";
  };

  # Fix a test case
  patches = [(fetchpatch {
    url = "https://github.com/ocaml-batteries-team/batteries-included/commit/7cbd9617d4efa5b3d647b1cc99d9a25fa01ac6dd.patch";
    sha256 = "0q4kq10psr7n1xdv4rspk959n1a5mk9524pzm5v68ab2gkcgm8sk";

  })];

  buildInputs = [ ocaml findlib ocamlbuild ];
  checkInputs = [ qtest ];
  propagatedBuildInputs = [ num ];

  doCheck = stdenv.lib.versionAtLeast ocaml.version "4.04" && !stdenv.isAarch64;
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
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
