{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, futures
, docloud
, requests
}:

buildPythonPackage rec {
  pname = "docplex";
  version = "2.18.200";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "340848e67e1389b32b44d16a100aed1ebb0a6f0519b0f3cbce7cd0de6478fd6c";
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
