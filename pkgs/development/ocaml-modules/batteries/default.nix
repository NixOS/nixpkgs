{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, qcheck, num, camlp-streams
, doCheck ? lib.versionAtLeast ocaml.version "4.08" && !stdenv.isAarch64
}:

if lib.versionOlder ocaml.version "4.02"
then throw "batteries is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-batteries";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    rev = "v${version}";
    hash = "sha256-D/0h0/70V8jmzHIUR6i2sT2Jz9/+tfR2dQgp4Bxtimc=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  nativeCheckInputs = [ qtest ];
  checkInputs = [ qcheck ];
  propagatedBuildInputs = [ camlp-streams num ];

  strictDeps = true;

  inherit doCheck;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = "https://ocaml-batteries-team.github.io/batteries-included/hdoc2/";
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
