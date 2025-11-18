{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-click,
  mkdocs-material,
}:

buildPythonPackage rec {
  pname = "mkdocs-glightbox";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blueswen";
    repo = "mkdocs-glightbox";
    tag = "v${version}";
    hash = "sha256-9HgXK7cE2z0fvKwEpCG5PTaaqGiet9KMNN2Ys9VJgeE=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-click
    mkdocs-material
  ];

  disabledTests = [
    # Checks compatible with material privacy plugin, which is currently not packaged in nixpkgs.
    "privacy"
    # mkdocs_glightbox.plugin:plugin.py:221 Error in wrapping img tag with anchor tag: 'NoneType' object has no attribute 'group' <img data-title="example" />
    "test_error"
  ];

  pythonImportsCheck = [
    "mkdocs_glightbox"
  ];

  meta = {
    description = "MkDocs plugin supports image lightbox (zoom effect) with GLightbox";
    homepage = "https://github.com/blueswen/mkdocs-glightbox";
    changelog = "https://github.com/blueswen/mkdocs-glightbox/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
