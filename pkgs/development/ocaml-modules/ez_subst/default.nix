{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_expect,
  ppx_inline_test,
}:

buildDunePackage (finalAttrs: {
  pname = "ez_subst";
  version = "0.2.1";

  minimalOCamlVersion = "4.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ez_subst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d0+H9dxLioa9QHnf2mF+MBk563qxc7YBhpmV1A0uv0s=";
  };

  propagatedBuildInputs = [
    ppx_inline_test
    ppx_expect
  ];

  doCheck = true;

  meta = {
    description = "Simple substitution module for OCaml";
    homepage = "https://github.com/OCamlPro/ez_subst";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
