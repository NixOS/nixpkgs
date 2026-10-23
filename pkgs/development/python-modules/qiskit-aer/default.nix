{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build
  cmake,
  setuptools,
  scikit-build,
  pybind11,
  ninja,
  blas,
  nlohmann_json,
  spdlog,

  # runtime dependencies
  qiskit,
  numpy,
  scipy,
  psutil,
  python-dateutil,

  # test dependencies
  stestrCheckHook,
  ddt,
  fixtures,
  ipython,
  sympy,
  matplotlib,
  seaborn,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-aer";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    tag = finalAttrs.version;
    hash = "sha256-aVmGoLMnDjV3iB9s4tvcL62zKvH/p70mqeGsxHzi3nc=";
  };

  dontUseCmakeConfigure = true;

  # build fails even if setting DISABLE_CONAN flag
  postPatch = ''
    sed -i -e '/conan/d' pyproject.toml
  '';

  patches = [
    # required for tests in qiskit
    (fetchpatch {
      name = "fix-json-conversion.patch";
      url = "https://github.com/Qiskit/qiskit-aer/pull/2418.patch";
      hash = "sha256-AGy+i6Rqj9WID8NxBxUR8SihqGfNtcBH1dLRFEoPGMI=";
    })
    # required for tests in qiskit-aer
    (fetchpatch {
      name = "fix-numpy-cross.patch";
      url = "https://github.com/Qiskit/qiskit-aer/commit/fc8dcafd1afa59ed7a837f0b6d39a95399f9afd7.patch";
      includes = [ "test/terra/states/test_aer_statevector.py" ];
      hash = "sha256-Nnr7+Fy+4b2B2fPkAzHg/6ZwE/fNfY1ko5AkGqutZTk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    pybind11
    scikit-build
    setuptools
  ];

  dependencies = [
    scipy
    numpy
    psutil
    python-dateutil
    qiskit
  ];

  buildInputs = [
    blas
    nlohmann_json
    spdlog
  ];

  preBuild = ''
    export DISABLE_CONAN=ON
  '';

  pythonImportsCheck = [
    "qiskit_aer"
    "qiskit_aer.primitives"
    "qiskit_aer.noise"
    "qiskit_aer.library"
    "qiskit_aer.backends.controller_wrappers"
  ];

  nativeCheckInputs = [
    ddt
    fixtures
    stestrCheckHook
    ipython
    matplotlib
    sympy
    seaborn
  ];

  # required for test_fusion_parallelization test
  env.OMP_NUM_THREADS = "2";

  # optional test; qiskit_qasm3_import dependency is not in nixpkgs yet
  disabledTestsRegex = [ "test_save_statevector_for_qasm3_circuit" ];

  preCheck = ''
    mv qiskit_aer qiskit_aer-source
  '';

  meta = {
    description = "High performance simulators for Qiskit";
    # broken on darwin for unknown reasons
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://qiskit.github.io/qiskit-aer/";
    downloadPage = "https://github.com/QISKit/qiskit-aer/releases";
    changelog = "https://qiskit.github.io/qiskit-aer/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
