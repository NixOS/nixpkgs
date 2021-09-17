{ lib, fetchPypi, buildPythonPackage, isPy3k, boost, numpy, pytestCheckHook, pytest-benchmark }:

buildPythonPackage rec {
  pname = "boost-histogram";
  version = "1.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "boost_histogram";
    inherit version;
    sha256 = "370e8e44a0bac4ebbedb7e62570be3a75a7a3807a297d6e82a94301b4681fc22";
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
