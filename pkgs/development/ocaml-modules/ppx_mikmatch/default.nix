{
  applyPatches,
  buildDunePackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  menhir,
  menhirLib,
  ounit2,
  ppxlib,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_mikmatch";
  version = "1.0";
  minimalOCamlVersion = "4.02.3";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "ahrefs";
      repo = "ppx_mikmatch";
      tag = finalAttrs.version;
      hash = "sha256-ZWZ7pJFifI0CDFXJIdIbdbH2VMdy+m2TKRDOl1YdwB0=";
    };
    patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/ahrefs/ppx_mikmatch/pull/2.patch";
      hash = "sha256-Zr77JnfphOAxtc/lW4KG0/cu9UiRHtnG08FiaEDd+44=";
    });
  };
  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    menhirLib
    ppxlib
    re
  ];
  checkInputs = [ ounit2 ];
  doCheck = true;
  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Matching Regular Expressions with OCaml Patterns using Mikmatch's syntax";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.vog ];
  };
})
