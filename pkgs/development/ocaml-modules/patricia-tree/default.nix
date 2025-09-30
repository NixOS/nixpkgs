{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  findlib,
  mdx,
  qcheck-core,
  ppx_inline_test,
}:

buildDunePackage rec {
  pname = "patricia-tree";
  version = "0.11.0";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "codex-semantics-library";
    repo = "patricia-tree";
    tag = "v${version}";
    hash = "sha256-lpmU0KhsyIHxPBiw38ssA7XFEMsRvOT03MByoJG88Xs=";
  };

  nativeCheckInputs = [
    mdx.bin
  ];

  checkInputs = [
    mdx
    ppx_inline_test
    qcheck-core
  ];

  doCheck = true;

  meta = {
    description = "Patricia Tree data structure in OCaml";
    homepage = "https://codex.top/api/patricia-tree/";
    downloadPage = "https://github.com/codex-semantics-library/patricia-tree";
    changelog = "https://github.com/codex-semantics-library/patricia-tree/releases/tag/v${version}";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
