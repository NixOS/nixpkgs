{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-ecobee-api";
    tag = version;
    hash = "sha256-6uZc022C3EgEgsPGD302qAtFqubwQSETQr3SQSYXeb8=";
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
