{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.2.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-ecobee-api";
    rev = "refs/tags/${version}";
    hash = "sha256-WBVHlA7cAQGCFRNSANX6PqPQYMRw74GEAlTFwSBxVQU=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyecobee" ];

  meta = with lib; {
    description = "Python API for talking to Ecobee thermostats";
    homepage = "https://github.com/nkgilley/python-ecobee-api";
    changelog = "https://github.com/nkgilley/python-ecobee-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
