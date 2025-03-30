{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "enochecker-core";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "enochecker_core";
    hash = "sha256-N41p2XRCp55rcPXLpA4rPIARsva/dQzK8qafjzXtavI=";
  };

  pythonImportsCheck = [ "enochecker_core" ];

  # no tests upstream
  doCheck = false;

  meta = with lib; {
    description = "Base library for enochecker libs";
    homepage = "https://github.com/enowars/enochecker_core";
    changelog = "https://github.com/enowars/enochecker_core/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fwc ];
  };
}
