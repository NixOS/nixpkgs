{
  applyPatches,
  buildDunePackage,
  fetchpatch,
  fetchurl,
  lib,
  menhir,
  ounit2,
  ppxlib,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_mikmatch";
  version = "1.1";
  src = applyPatches {
    src = fetchurl {
      name = "ppx_mikmatch-${finalAttrs.version}.tar.gz";
      url = "https://codeload.github.com/ahrefs/ppx_mikmatch/tar.gz/refs/tags/${finalAttrs.version}";
      hash = "sha256-Q4BF/YNntwU0z1MScA700RVjXu4w81BZlAASMluHJXE=";
    };
    patches = [
      (fetchpatch {
        name = "ppx_mikmatch_remove_conflict_with_ppx_regexp.patch";
        url = "https://github.com/ahrefs/ppx_mikmatch/commit/cfbe40c9cc1952768a5c47ee0ac545db78b7511a.patch";
        hash = "sha256-2a1moRKo9Bd8hMP/tAPJorE49aV0yYxlZpSZ8HjT9h8=";
      })
    ];
    postPatch = ''
      mv src/ppx_regexp.ml src/ppx_mikmatch.ml
      mv tests/test_ppx_regexp.ml tests/test_ppx_mikmatch.ml
      mv tests/test_ppx_regexp_module.ml tests/test_ppx_mikmatch_module.ml
      mv tests/test_ppx_regexp_unused.ml tests/test_ppx_mikmatch_unused.ml
    '';
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    ppxlib
    re
  ];

  checkInputs = [ ounit2 ];
  doCheck = true;

  meta = {
    description = "Matching Regular Expressions with OCaml Patterns using Mikmatch's syntax";
    homepage = "https://github.com/ahrefs/ppx_mikmatch";
    license = lib.licenses.lgpl3Plus;
    maintainers = [
      lib.maintainers.vog
      lib.maintainers.zazedd
    ];
  };
})
