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
  version = "2.14.186";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "ba78897869e938c9ad1cb58e7d82bcf693f5e9a0dfa5e2dbfcee2ae5ea5e87f8";
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
