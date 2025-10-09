{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  netaddr,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pybbox";
  version = "0.0.5-alpha";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "HydrelioxGitHub";
    repo = "pybbox";
    rev = version;
    hash = "sha256-xealTlH/rMlqEnENZXq0/EVDlF8lc/B8qeUmQPM6fUc=";
  };

  propagatedBuildInputs = [
    netaddr
    requests
  ];

  # Tests are incomplete and contain failing tests
  doCheck = false;

  pythonImportsCheck = [ "pybbox" ];

  meta = {
    description = "Python library for the Bouygues BBox Routeur API";
    homepage = "https://github.com/HydrelioxGitHub/pybbox";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
