{
  lib,
  fetchzip,
  buildDunePackage,
  ocaml,
  findlib,
  zarith,
  cppo,
}:

buildDunePackage (finalAttrs: {
  pname = "malfunction";
  version = "0.7.1";

  src = fetchzip {
    url = "https://github.com/stedolan/malfunction/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    hash = "sha256-Cpe5rSBvsr3pqbucGZelutPoI+bcQPFCbdcKsE/HieY=";
  };

  propagatedBuildInputs = [
    findlib
    zarith
  ];
  nativeBuildInputs = [
    cppo
  ];

  meta = {
    homepage = "http://github.com/stedolan/malfunction";
    description = "Malfunction is a high-performance, low-level untyped program representation, designed as a target for compilers of functional programming languages.";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ _4ever2 ];
    mainProgram = "malfunction";
    broken = lib.versionAtLeast ocaml.version "5.4";
  };
})
