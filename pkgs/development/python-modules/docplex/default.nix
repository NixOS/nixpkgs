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
  version = "2.16.196";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "8fd96e3586444e577b356c0ac62511414e76027ff159ebe0d0b3e44b881406d1";
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
