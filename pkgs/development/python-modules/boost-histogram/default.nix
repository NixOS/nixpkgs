{ lib, fetchPypi, buildPythonPackage, isPy3k, boost, numpy, pytestCheckHook, pytest-benchmark, setuptools-scm }:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.3.1";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    sha256 = "sha256-Mc05Zlbzo3g04H0wTNuE2ZBrwhcmJqPZL+V30IvPQQ8=";
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
