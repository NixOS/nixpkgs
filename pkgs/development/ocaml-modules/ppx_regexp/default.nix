{
  applyPatches,
  buildDunePackage,
  fetchpatch,
  fetchurl,
  lib,
  ppxlib,
  qcheck,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_regexp";
  version = "0.5.1";
  src = applyPatches {
    src = fetchurl {
      url = "https://github.com/paurkedal/ppx_regexp/releases/download/v${finalAttrs.version}/ppx_regexp-v${finalAttrs.version}.tbz";
      hash = "sha256-JQg7xHxsoiS1LZWOMnLJOMERWJVEbtUmyjMPA6LVDKg=";
    };
    patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/paurkedal/ppx_regexp/pull/17.patch";
      hash = "sha256-aijwUbTv6vT3IX1u8gZK9l7ndfKVRhfdKl62aa63UnA=";
      includes = [ "*.ml" ];
    });
  };

  propagatedBuildInputs = [
    ppxlib
    re
  ];

  checkInputs = [ qcheck ];
  doCheck = false; # Tests are failing. This might be related to a recent update of qcheck.

  meta = {
    description = "Regular Expression Matching with OCaml Patterns";
    homepage = "https://github.com/paurkedal/ppx_regexp";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.vog ];
  };
})
