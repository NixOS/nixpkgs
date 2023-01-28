{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, boost
, numpy
, pytestCheckHook
, pytest-benchmark
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    hash = "sha256-4XXvvBBUonvFP7vpVHLKyeqTmZyR0GEYQNd2uZWI1Ro=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    boost
  ];

  propagatedBuildInputs = [
    numpy
  ];

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
