{ lib, fetchPypi, buildPythonPackage, isPy3k, boost, numpy, pytestCheckHook, pytest-benchmark, setuptools-scm }:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.2.1";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    sha256 = "a27842b2f1cfecc509382da2b25b03056354696482b38ec3c0220af0fc9b7579";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ boost ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook pytest-benchmark ];

  meta = with lib; {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
