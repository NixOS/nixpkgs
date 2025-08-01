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
    sha256 = "996d55407498fd01e6c6c480f367048f92255e9ca9db0e9ea19aaef91328a441";
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
