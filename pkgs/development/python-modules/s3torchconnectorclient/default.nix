{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  pytestCheckHook,
  cmake,
  hypothesis,
  rustPackages,
  setuptools-rust,
  torch,
}:

let
  inherit (rustPackages) rustPlatform rustc cargo;

in
buildPythonPackage rec {
  pname = "s3torchconnectorclient";
  version = "1.5.0";
  format = "pyproject";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "s3-connector-for-pytorch";
    rev = "v${version}";
    hash = "sha256-ovy/VUWTYMQ3wbmLptqj6l+uVwl4Gbkt3OpPUPayuLI=";
  };

  sourceRoot = "${src.name}/s3torchconnectorclient";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src sourceRoot;
    hash = "sha256-xYfBnyZM43FNxPnnP6a45ZLCCve/B3713RNmgG0LNBc=";
  };

  nativeBuildInputs = [
    cargo
    cmake
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    setuptools-rust
  ];

  # Patch metrics-0.24.1 to fix E0521 borrow-checker error under newer rustc.
  # Backport of the fix from metrics 0.24.2. See: https://github.com/rust-lang/rust/issues/141402
  postPatch = ''
    patch -d $cargoDepsCopy/*/metrics-0.24.1 -p1 < ${./fix-metrics-0.24.1-E0521.patch}
  '';

  # cmake is needed/used by the rust toolchain, we don't want Nix to run it directly
  dontUseCmakeConfigure = true;

  env = {
    CFLAGS = "-Wno-stringop-overflow -Wno-array-bounds -Wno-restrict";
    # pyo3-0.24.1 declares support only up to Python 3.13; use stable ABI for forward compat
    PYO3_USE_ABI3_FORWARD_COMPATIBILITY = "1";
  };

  dependencies = [
    boto3
    torch
  ];

  pythonImportsCheck = [ "s3torchconnectorclient" ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTestPaths = [
    # integration tests access S3
    "python/tst/integration/"
    # unit tests for S3 client creation require AWS credentials + TLS trust store
    "python/tst/unit/test_mountpoint_s3_client.py"
  ];

  meta = with lib; {
    description = "Low-level S3 client for PyTorch data loading";
    homepage = "https://github.com/awslabs/s3-connector-for-pytorch";
    changelog = "https://github.com/awslabs/s3-connector-for-pytorch/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jherland ];
  };
}
