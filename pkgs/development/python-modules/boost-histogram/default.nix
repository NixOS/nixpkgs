{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  cmake,
  pybind11,
  nanobind,
  ninja,
  setuptools-scm,
  boost,
  numpy,
  pytestCheckHook,
  pytest-benchmark,
  scikit-build-core,
}:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    hash = "sha256-BiPwEObFLl0Bh2dyOVloYJDbB/ww8NHYR1tdZjxd2yw=";
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

  meta = with lib; {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
