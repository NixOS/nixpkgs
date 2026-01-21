{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  capstone,
  cmsis-pack-manager,
  colorama,
  importlib-metadata,
  importlib-resources,
  intelhex,
  intervaltree,
  lark,
  natsort,
  prettytable,
  pyelftools,
  pylink-square,
  pyusb,
  pyyaml,
  typing-extensions,
  hidapi,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyocd";
  version = "0.42.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "pyOCD";
    tag = "v${version}";
    hash = "sha256-VSEItt+mXiV3u3SAKQc8uGiJdT6b4nER/u6BwfaX2CM=";
  };

  pythonRelaxDeps = [ "capstone" ];
  pythonRemoveDeps = [ "libusb-package" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    capstone
    cmsis-pack-manager
    colorama
    importlib-metadata
    importlib-resources
    intelhex
    intervaltree
    lark
    natsort
    prettytable
    pyelftools
    pylink-square
    pyusb
    pyyaml
    typing-extensions
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [ hidapi ];

  pythonImportsCheck = [ "pyocd" ];

  disabledTests = [
    # AttributeError: 'not_called' is not a valid assertion
    # Upstream fix at https://github.com/pyocd/pyOCD/pull/1710
    "test_transfer_err_not_flushed"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/pyocd/pyOCD/releases/tag/${src.tag}";
    description = "Python library for programming and debugging Arm Cortex-M microcontrollers";
    downloadPage = "https://github.com/pyocd/pyOCD";
    homepage = "https://pyocd.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      frogamic
      sbruder
    ];
  };
}
