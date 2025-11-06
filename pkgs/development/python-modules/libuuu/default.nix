{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  autoPatchelfHook,
  udev,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libuuu";
  version = "1.5.233";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SbnQs+khNT1DwrctwHi0rsuO1WR/KgA7TUFARw9AHAU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  pythonRelaxDeps = [
    "setuptools-scm"
  ];

  dependencies = [
    setuptools-scm
  ];

  pythonImportsCheck = [
    "libuuu"
  ];

  # Prevent tests to load the plugin from the source files instead of the installed ones
  preCheck = ''
    rm -rf libuuu
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python wrapper for libuuu";
    homepage = "https://github.com/nxp-imx/mfgtools/tree/master/wrapper";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # The pypi archive does not contain the pre-built library for these platforms
      "aarch64-linux"
      "x86_64-darwin"
    ];
  };
}
