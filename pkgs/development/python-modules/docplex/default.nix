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
  version = "2.23.222";

  # No source available from official repo
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-c5XpfEGTkojgzk+ATHCSzzh04zeEVJEEKBp+lPfS+x4=";
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
