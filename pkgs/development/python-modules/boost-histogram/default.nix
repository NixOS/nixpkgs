{
  lib,
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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "boost-histogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-GsgzJqZTrtc4KRkGn468m0e+sgX9rzJdwA9JMPSSPWk=";
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

  meta = {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    changelog = "https://github.com/scikit-hep/boost-histogram/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
