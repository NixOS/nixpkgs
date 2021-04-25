{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook , pytestcov , numba
, numpy
, scikitlearn
, scipy
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.2.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "v${version}";
    sha256 = "0izjc68rb6sr3x55c3zzraakzspgzh80qykfax9zj868zypfm365";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scikitlearn
    scipy
  ];

  checkInputs = [ pytestCheckHook pytestcov ];
  pytestFlagsArray = [ "--ignore=docs" ];

  meta = with lib; {
    homepage = "https://github.com/neurodata/hyppo";
    description = "Indepedence testing in Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
