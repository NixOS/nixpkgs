{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  boto3,
  posthog,
  py-machineid,
  pydantic,
  requests,
  sentry-sdk,
}:
buildPythonPackage rec {
  pname = "pyepsilla";
  version = "0.3.15";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "epsilla-cloud";
    repo = "epsilla-python-client";
    rev = version;
    hash = "sha256-ebeq6J6BeGHqYIlA02YK59S1vsYwXQZ2CgkCG3Wi16I=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    posthog
    py-machineid
    pydantic
    requests
    sentry-sdk
  ];

  pythonImportsCheck = [ "pyepsilla" ];

  meta = with lib; {
    description = "Python client for Epsilla Vector Database";
    homepage = "https://github.com/epsilla-cloud/epsilla-python-client";
    changelog = "https://github.com/epsilla-cloud/epsilla-python-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ loicreynier ];
  };
}
