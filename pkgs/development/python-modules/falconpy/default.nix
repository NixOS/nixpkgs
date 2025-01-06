{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "falconpy";
  version = "v1.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CrowdStrike";
    repo = "falconpy";
    tag = version;
    hash = "sha256-boebQI//NenEqctQbEdxiXKU3/07C6jVzWVHecmJjPk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "falconpy" ];

  meta = {
    description = "The CrowdStrike Falcon SDK for Python";
    homepage = "https://github.com/CrowdStrike/falconpy";
    changelog = "https://github.com/CrowdStrike/falconpy/releases/tag/${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
