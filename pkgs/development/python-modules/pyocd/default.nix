{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  setuptools-scm,
  typing-extensions,
  stdenv,
  hidapi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyocd";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "pyOCD";
    tag = "v${version}";
    hash = "sha256-4fdVcTNH125e74S3mA/quuDun17ntGCazX6CV+obUGc=";
  };

  patches = [
    # https://github.com/pyocd/pyOCD/pull/1332
    # merged into develop
    (fetchpatch {
      name = "libusb-package-optional.patch";
      url = "https://github.com/pyocd/pyOCD/commit/0b980cf253e3714dd2eaf0bddeb7172d14089649.patch";
      hash = "sha256-B2+50VntcQELeakJbCeJdgI1iBU+h2NkXqba+LRYa/0=";
    })
  ];

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

  meta = with lib; {
    changelog = "https://github.com/pyocd/pyOCD/releases/tag/${src.tag}";
    description = "Python library for programming and debugging Arm Cortex-M microcontrollers";
    downloadPage = "https://github.com/pyocd/pyOCD";
    homepage = "https://pyocd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
  };
}
