{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, qcheck, num, ounit
, doCheck ? lib.versionAtLeast ocaml.version "4.08" && !stdenv.isAarch64
}:

if lib.versionOlder ocaml.version "4.02"
then throw "batteries is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-batteries";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    rev = "v${version}";
    sha256 = "sha256-lLlpsg1v7mYFJ61rTdLV2v8/McK1R4HDTTuyka48aBw=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  checkInputs = [ qtest ounit qcheck ];
  propagatedBuildInputs = [ num ];

  strictDeps = !doCheck;

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
    inherit (ocaml.meta) platforms;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
