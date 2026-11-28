{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  nixfmt,
  pygments,
  tree-sitter,
  tree-sitter-grammars,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nix-manipulator";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hoh";
    repo = "nix-manipulator";
    tag = finalAttrs.version;
    hash = "sha256-V4UR7uk6NGgyUTbeIJ9IBKMzakcn27aOkwYxYWCB45Q=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pygments
    tree-sitter
    tree-sitter-grammars.tree-sitter-nix
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nixfmt
  ];

  # nixfmt >= 1.5 compacts short functions onto a single line ({ a }: { ... });
  # normalize whitespace in formatting validation to accept both forms.
  postPatch = ''
    substituteInPlace tests/nixfmt_helpers.py \
      --replace-fail 'import shutil' 'import re, shutil' \
      --replace-fail 'if formatted != expected:' 'if formatted != expected and re.sub(r"\s+", " ", expected) != re.sub(r"\s+", " ", formatted):'
  '';

  pythonImportsCheck = [
    "nix_manipulator"
  ];

  meta = {
    description = "Python library for parsing, manipulating, and reconstructing Nix source code";
    homepage = "https://codeberg.org/hoh/nix-manipulator";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      hoh
      phanirithvij
    ];
  };
})
