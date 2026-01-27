{
  applyPatches,
  buildDunePackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  ppxlib,
  qcheck,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_regexp";
  version = "0.5.1";
  minimalOCamlVersion = "4.02.3";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "paurkedal";
      repo = "ppx_regexp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Yfh0v9Cobc9Kd+wLiBX1Mithc2hwQmoIwlelAyiVTXo=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/paurkedal/ppx_regexp/commit/2a629ef9a3ea30c31228c17d0f85e9b9ca65e7e7.patch";
        hash = "sha256-B3j2uzSXSdiQ7JbQdo98YWFwbpmSdcbmMpyFHaYfP3U=";
      })
    ]
    ++ lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/paurkedal/ppx_regexp/pull/17.patch";
      hash = "sha256-ArzwTZvDXSKP9GX2GnksrP8IzT/wWliKpGArsi4ClpY=";
    });
  };
  propagatedBuildInputs = [
    ppxlib
    re
  ];
  checkInputs = [ qcheck ];
  doCheck = true;
  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Regular Expression Matching with OCaml Patterns";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.vog ];
  };
})
