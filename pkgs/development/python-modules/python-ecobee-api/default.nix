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
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-ecobee-api";
    tag = version;
    hash = "sha256-dJ7dVceYfmJHvk2OEXtRW/U8h2jFDc2aC58WmqhyP+k=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyecobee" ];

  meta = with lib; {
    description = "Python API for talking to Ecobee thermostats";
    homepage = "https://github.com/nkgilley/python-ecobee-api";
    changelog = "https://github.com/nkgilley/python-ecobee-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
