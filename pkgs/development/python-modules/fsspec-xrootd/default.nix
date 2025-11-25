{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  fsspec,
  xrootd,

  # tests
  pkgs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fsspec-xrootd";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "fsspec-xrootd";
    tag = "v${version}";
    hash = "sha256-Vpe/Gcm6rmehG05h2H7BDZcBQDyie0Ww9X8LgoTgAkE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fsspec
    xrootd
  ];

  pythonImportsCheck = [ "fsspec_xrootd" ];

  nativeCheckInputs = [
    pkgs.xrootd
    pytestCheckHook
  ];

  disabledTests = [
    # Fails (on aarch64-linux) as it runs sleep, touch, stat and makes assumptions about the
    # scheduler and the filesystem.
    "test_touch_modified"
  ];

  # Timeout related tests hang indifinetely
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_basicio.py" ];

  meta = {
    description = "XRootD implementation for fsspec";
    homepage = "https://github.com/CoffeaTeam/fsspec-xrootd";
    changelog = "https://github.com/CoffeaTeam/fsspec-xrootd/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
