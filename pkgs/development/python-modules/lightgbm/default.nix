{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scipy
, scikitlearn
}:

buildPythonPackage rec {
  pname = "lightgbm";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40354d21da6bfa73c7ada4d01b2e0b22eaae00f93e90bdaf3fc423020c273890";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    scikitlearn
  ];

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;

  meta = with lib; {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = https://github.com/Microsoft/LightGBM;
    license = licenses.mit;
    maintainers = with lib.maintainers; [ teh costrouc ];
  };
}
