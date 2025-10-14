{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  blas,
  cmake,
  ninja,
  nlohmann_json,
  spdlog,
  numpy,
  pybind11,
  scikit-build,
  qiskit,
  psutil,
  scipy,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    tag = version;
    hash = "sha256-aVmGoLMnDjV3iB9s4tvcL62zKvH/p70mqeGsxHzi3nc=";
  };

  dontUseCmakeConfigure = true;

  # build fails even if setting DISABLE_CONAN flag
  postPatch = ''
    sed -i -e '/conan/d' pyproject.toml
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    pybind11
    scikit-build
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

  doCheck = false;

  meta = {
    description = "High performance simulators for Qiskit";
    homepage = "https://qiskit.github.io/qiskit-aer/";
    downloadPage = "https://github.com/QISKit/qiskit-aer/releases";
    changelog = "https://qiskit.github.io/qiskit-aer/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
