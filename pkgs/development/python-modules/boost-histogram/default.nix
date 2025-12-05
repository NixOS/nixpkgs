{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # build-system
  pybind11,
  nanobind,
  ninja,
  scikit-build-core,
  setuptools-scm,

  # buildInputs
  boost,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
  pytest-benchmark,
  pytest-xdist,
  cloudpickle,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "boost-histogram";
    tag = "v${version}";
    hash = "sha256-kduE5v1oQT76MRxMuGo+snCBdJ+yOjkOJFO45twcUIs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  dontUseCmakeConfigure = true;

  build-system = [
    pybind11
    nanobind
    ninja
    scikit-build-core
    setuptools-scm
  ];

  buildInputs = [ boost ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
    pytest-xdist
    cloudpickle
    hypothesis
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Segfaults: boost_histogram/_internal/hist.py", line 799 in sum
    # Fatal Python error: Segmentation fault
    "test_numpy_conversion_4"
  ];

  pythonImportsCheck = [ "boost_histogram" ];

  meta = {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    changelog = "https://github.com/scikit-hep/boost-histogram/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
