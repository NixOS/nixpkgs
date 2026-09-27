{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  autobean-refactor,
  nix-update-script,
  pdm-backend,
  pytest-cov-stub,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "autobean-format";
  version = "0.1.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SEIAROTg";
    repo = "autobean-format";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NeuGCUS/7ZS5GnvtAwlbAWU7PY7FBNwwA6uoANMXnlg=";
  };

  patches = [
    # Fix for https://github.com/SEIAROTg/autobean-format/issues/15 not yet released
    (fetchpatch {
      name = "support-multi-semi-colon-in-block-comments.patch";
      url = "https://github.com/SEIAROTg/autobean-format/commit/545fbb8ba4b29622f0716919b8798f435bbf414c.patch";
      hash = "sha256-Qdud7CH/FQ1pVAXmgXcRWsrPmg3w1fT2q+1Td12aIuU=";
    })
    # Fix for https://github.com/SEIAROTg/autobean-format/issues/16 not yet released
    (fetchpatch {
      name = "accept-ignored-lines-as-compartment-separator.patch";
      url = "https://github.com/SEIAROTg/autobean-format/commit/e73c0159b4d0cdc8ea219565c7da2f5fbe97ead6.patch";
      hash = "sha256-sYaCUQPR1Own31oY/aFTb7v4lEsgEi/zb4Wg18cBCmA=";
    })
  ];

  build-system = [
    pdm-backend
  ];

  dependencies = [
    autobean-refactor
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "autobean_format" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/SEIAROTg/autobean-format";
    description = "Yet another formatter for beancount";
    mainProgram = "autobean-format";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
