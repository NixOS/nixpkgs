{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "orderly-set";
  version = "5.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "orderly-set";
    rev = "refs/tags/${version}";
    hash = "sha256-ZDo5fSHD0lCn9CRQtWK10QeZoOhuXG3LR3KA/to9gpE=";
  };
  patches = [
    # https://github.com/seperman/orderly-set/pull/5
    (fetchpatch {
      name = "do-not-import-mypy.patch";
      url = "https://github.com/seperman/orderly-set/commit/34362084868a081b8ebaaf1f13c93a7a798ef557.patch";
      hash = "sha256-eKbnA31ykm5fH0om6cfOaMpy+ZNNWRDkHieaUIHF8OM=";
    })
  ];

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "orderly_set"
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];
  disabledTests = [
    # Statically analyzes types, can be disabled so that mypy won't be needed.
    "test_typing_mypy"
  ];

  meta = {
    description = "Orderly Set previously known as Ordered Set";
    homepage = "https://github.com/seperman/orderly-set";
    changelog = "https://github.com/seperman/orderly-set/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
