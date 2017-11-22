{ stdenv
, fetchPypi
, cmake
# Python deps
, numpy
, scipy
, scikitlearn
, buildPythonPackage
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "lightgbm";
  version = "2.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f1drk3s9sfhscp3dvsxhrnn2ajhfrn65rz4gwl09lasy2b8s6wh";
  };

  propagatedBuildInputs = [ numpy scipy scikitlearn ];
  buildInputs = [
    cmake
  ];

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = https://github.com/Microsoft/LightGBM;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ teh ];
  };
}
