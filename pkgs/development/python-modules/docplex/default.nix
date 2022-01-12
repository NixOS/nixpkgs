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
  version = "2.22.213";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "8a86bba42b5b65f2e0f88ed350115efeb783b444661e2cfcf3a67d5c59bcb0bd";
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
