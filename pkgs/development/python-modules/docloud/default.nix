{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "docloud";
  version = "1.0.375";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mW1VQHSY/QHmxsSA82cEj5IlXpyp2w6eoZqu+RMopEE=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # Pypi's tarball doesn't contain tests. Source not available.
  doCheck = false;
  pythonImportsCheck = [ "docloud" ];

  meta = with lib; {
    description = "IBM Decision Optimization on Cloud Python client";
    homepage = "https://onboarding-oaas.docloud.ibmcloud.com/software/analytics/docloud/";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
