{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "coincurve";
  version = "21.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "coincurve";
    tag = "v${version}";
    hash = "sha256-+8/CsV2BTKZ5O2LIh5/kOKMfFrkt2Jsjuj37oiOgO6Y=";
  };

  patches = [
    (fetchpatch2 {
      # Fixes build against modern `hatchling`.
      # <https://github.com/ofek/coincurve/pull/188>
      name = "Add `get_cffi_distribution_license_files()`";
      url = "https://github.com/ofek/coincurve/commit/19597b0869803acfc669d916e43c669e9ffcced7.patch";
      hash = "sha256-mULl4uS1XNLgcR7jtsaxKjYaYox6Vv3JavgV4u7zXYY=";
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

  meta = with lib; {
    description = "Cross-platform bindings for libsecp256k1";
    homepage = "https://github.com/ofek/coincurve";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
