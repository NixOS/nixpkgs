{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  withStatic ? false,
}:

stdenv.mkDerivation (
  rec {
    version = "1.6";
    pname = "ocaml${ocaml.version}-num";
    src = fetchFromGitHub {
      owner = "ocaml";
      repo = "num";
      tag = "v${version}";
      hash = "sha256-JWn0WBsbKpiUlxRDaXmwXVbL2WhqQIDrXiZk1aXeEtQ=";
    };

    patches = lib.optional withStatic ./enable-static.patch;

    postPatch = ''
      substituteInPlace num.opam --replace-fail '1.7~dev' "${version}"
      substituteInPlace src/Makefile --replace-fail "cp META.num META" "mv META.num META"
    '';

    nativeBuildInputs = [
      ocaml
      findlib
    ];

    strictDeps = true;

    createFindlibDestdir = true;

    installTargets = "findlib-install";

    meta = {
      description = "Legacy Num library for arbitrary-precision integer and rational arithmetic";
      license = lib.licenses.lgpl21;
      inherit (ocaml.meta) platforms;
      inherit (src.meta) homepage;
    };
  }
  // (lib.optionalAttrs (lib.versions.majorMinor ocaml.version == "4.06") {
    env.NIX_CFLAGS_COMPILE = "-fcommon";
  })
)
