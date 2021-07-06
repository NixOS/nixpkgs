{ lib, fetchPypi, buildPythonPackage, isPy3k, boost, numpy, pytestCheckHook, pytest-benchmark }:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    sha256 = "b79cb9a00c5b8e44ff24ffcbec0ce5d3048dd1570c8592066344b6d2f2369fa2";
  };

  buildInputs = [ boost ];
  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook pytest-benchmark ];

  meta = with lib; {
    description = "Python bindings for the C++14 Boost::Histogram library";
    homepage = "https://github.com/scikit-hep/boost-histogram";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
