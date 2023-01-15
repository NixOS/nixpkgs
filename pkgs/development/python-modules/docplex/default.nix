{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, futures ? null
, docloud
, requests
}:

buildPythonPackage rec {
  pname = "docplex";
  version = "2.24.232";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Mo4Ih/2ltIonP37BDyCi0fY2bkPt2ij1F0A1Ws1sF1g=";
  };

  propagatedBuildInputs = [
    docloud
    requests
  ] ++ lib.optional isPy27 futures;

  doCheck = false;
  pythonImportsCheck = [ "docplex" ];

  meta = with lib; {
    description = "IBM Decision Optimization CPLEX Modeling for Python";
    homepage = "https://onboarding-oaas.docloud.ibmcloud.com/software/analytics/docloud/";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
