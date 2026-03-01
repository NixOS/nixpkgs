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

buildPythonPackage (finalAttrs: {
  pname = "fsspec-xrootd";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "fsspec-xrootd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UKZO5lgOOfzyOsrDZ2En67Xhm+BKvHELGuvkwSHbolY=";
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
    # Hangs indefinitely
    "test_broken_server"

    # Fails (on aarch64-linux) as it runs sleep, touch, stat and makes assumptions about the
    # scheduler and the filesystem.
    "test_touch_modified"
  ];

  # Timeout related tests hang indifinetely
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_basicio.py" ];

  meta = {
    description = "XRootD implementation for fsspec";
    homepage = "https://github.com/CoffeaTeam/fsspec-xrootd";
    changelog = "https://github.com/CoffeaTeam/fsspec-xrootd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
