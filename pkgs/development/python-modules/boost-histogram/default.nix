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
}:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "boost-histogram";
    tag = "v${version}";
    hash = "sha256-7E4y3P3RzVmIHb5mEoEYWZSwWnmL3LbGqYjGbnszM98=";
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
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Segfaults: boost_histogram/_internal/hist.py", line 799 in sum
    # Fatal Python error: Segmentation fault
    "test_numpy_conversion_4"
  ];

  meta = {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    changelog = "https://github.com/scikit-hep/boost-histogram/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
