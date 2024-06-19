{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  fsspec,
  xrootd,
  pkgs,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "fsspec-xrootd";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "fsspec-xrootd";
    rev = "refs/tags/v${version}";
    hash = "sha256-fhamfMWlsiiqfU9c9XDfLEEkRbMAqm74rc2bGF3fRaM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "An XRootD implementation for fsspec";
    homepage = "https://github.com/CoffeaTeam/fsspec-xrootd";
    changelog = "https://github.com/CoffeaTeam/fsspec-xrootd/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
