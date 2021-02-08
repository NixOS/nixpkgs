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
  version = "2.20.204";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "24d8c3f54b4b1ec306c13b97c9d67e2f9fa93d0d9ea1b92bdba62df6982cd6a0";
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
