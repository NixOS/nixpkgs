{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-ecobee-api";
    tag = version;
    hash = "sha256-Gr0aLAX5Qv8COMjwvoqyhc7yBNMu6nbMCSBVT5FcX1Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyecobee" ];

  meta = {
    description = "Python API for talking to Ecobee thermostats";
    homepage = "https://github.com/nkgilley/python-ecobee-api";
    changelog = "https://github.com/nkgilley/python-ecobee-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
