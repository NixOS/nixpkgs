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
  version = "0.1.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qdnb1l4hz4dgwhapz1fp9sb2vxxvr8h2ngsbvyf50h3kapcn19r";
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
