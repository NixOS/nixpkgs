{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cmake,
  hatchling,
  ninja,
  pkg-config,
  setuptools,
  scikit-build-core,

  # dependencies
  asn1crypto,
  cffi,
  secp256k1,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "coincurve";
  version = "21.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "coincurve";
    tag = "v${version}";
    hash = "sha256-+8/CsV2BTKZ5O2LIh5/kOKMfFrkt2Jsjuj37oiOgO6Y=";
  };

  patches = [
    # Build requires cffi LICENSE files
    (fetchpatch {
      url = "https://github.com/ofek/coincurve/commit/19597b0869803acfc669d916e43c669e9ffcced7.patch";
      hash = "sha256-BkUxXjcwk3btcvSVaVZqVTJ+8E8CYtT5cTXLx9lxJ/g=";
    })
  ];

  build-system = [
    hatchling
    cffi
    cmake
    ninja
    pkg-config
    setuptools
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  env.COINCURVE_IGNORE_SYSTEM_LIB = "OFF";

  buildInputs = [ secp256k1 ];

  dependencies = [
    asn1crypto
    cffi
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "coincurve" ];

  meta = {
    description = "Cross-platform bindings for libsecp256k1";
    homepage = "https://github.com/ofek/coincurve";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ryand56 ];
  };
}
