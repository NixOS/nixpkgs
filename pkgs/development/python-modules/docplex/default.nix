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
  version = "2.15.194";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "976e9b4e18bccbabae04149c33247a795edb1f00110f1b511c5517ac6ac353bb";
  };

  requiredPythonModules = [
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
