{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, num, ounit
, doCheck ? lib.versionAtLeast ocaml.version "4.08" && !stdenv.isAarch64
}:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "batteries is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-batteries";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    rev = "v${version}";
    sha256 = "sha256:1cd7475n1mxhq482aidmhh27mq5p2vmb8d9fkb1mlza9pz5z66yq";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  checkInputs = [ qtest ounit ];
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
