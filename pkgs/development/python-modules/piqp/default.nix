{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  cpu_features,

  # build-system
  cmake,
  ninja,
  pybind11,
  scikit-build-core,

  # buildInputs
  eigen,
  gtest,
  matio,

  # tests
  numpy,
  scipy,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "piqp";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PREDICT-EPFL";
    repo = "piqp";
    tag = "v${version}";
    hash = "sha256-W9t7d+wV5WcphL54e6tpnKxiWFay9UrFmIRKsGk2yMM=";
  };

  patches = [
    (replaceVars ./use-nix-packages.patch {
      cpu_features_src = cpu_features.src;
    })
  ];

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    eigen
    gtest
    matio
  ];

  pythonImportsCheck = [ "piqp" ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    scipy
  ];

  meta = {
    description = "Proximal Interior Point Quadratic Programming solver";
    homepage = "https://github.com/PREDICT-EPFL/piqp";
    changelog = "https://github.com/PREDICT-EPFL/piqp/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
