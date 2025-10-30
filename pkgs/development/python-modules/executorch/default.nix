{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  certifi,
  cmake,
  packaging,
  pyyaml,
  setuptools,
  zstd,

  # dependencies
  # coremltools,
  expecttest,
  flatbuffers,
  hydra-core,
  hypothesis,
  kgb,
  mpmath,
  numpy,
  omegaconf,
  pandas,
  parameterized,
  pytest,
  pytest-json-report,
  pytest-rerunfailures,
  pytest-xdist,
  ruamel-yaml,
  scikit-learn,
  sympy,
  tabulate,
  torch,
  torchao,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "executorch";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "executorch";
    tag = "v${version}";

    # The ExecuTorch repo must be cloned into a directory named exactly `executorch`.
    # See https://github.com/pytorch/executorch/issues/6475 for progress on a fix for this restriction.
    name = "executorch";

    fetchSubmodules = true;
    hash = "sha256-WirvB+Tjh7HQK3m41/5xr8VThJAk+Cw7+cQAusWUCFM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pip>=23",' "" \
      --replace-fail "cmake>=3.29,<4.0.0" "cmake"
  ''
  # CMake 4 dropped support of versions lower than 3.5, versions lower than 3.10 are deprecated.
  # https://github.com/NixOS/nixpkgs/issues/445447
  + ''
    substituteInPlace backends/xnnpack/third-party/pthreadpool/CMakeLists.txt \
      --replace-fail \
        "CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)" \
        "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)"
  '';

  env = {
    BUILD_VERSION = version;
  };

  build-system = [
    certifi
    cmake
    packaging
    pyyaml
    setuptools
    zstd
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    # coremltools
    expecttest
    flatbuffers
    hydra-core
    hypothesis
    kgb
    mpmath
    numpy
    omegaconf
    packaging
    pandas
    parameterized
    pytest
    pytest-json-report
    pytest-rerunfailures
    pytest-xdist
    pyyaml
    ruamel-yaml
    scikit-learn
    sympy
    tabulate
    torch
    torchao
    typing-extensions
  ];

  pythonImportsCheck = [ "executorch" ];

  meta = {
    description = "On-device AI across mobile, embedded and edge for PyTorch";
    homepage = "https://github.com/pytorch/executorch";
    changelog = "https://github.com/pytorch/executorch/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "executorch";
  };
}
