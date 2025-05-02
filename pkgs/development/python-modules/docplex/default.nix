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
  version = "2.27.239";
  format = "setuptools";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ug5+jDBBbamqd0JebzHvjLZoTRRPYWQiJl6g8BK0aMQ=";
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
