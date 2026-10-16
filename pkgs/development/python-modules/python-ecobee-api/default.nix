{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-ecobee-api";
    tag = version;
    hash = "sha256-kvTbeXpjeD2T+dFVGldNH7H/3usTFQXD7tINp9UkftE=";
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
