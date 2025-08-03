{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "falconpy";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CrowdStrike";
    repo = "falconpy";
    tag = "v${version}";
    hash = "sha256-m/pW9M2HXTtu42UIOCq7J1lr+y9mc3N74lD+qaCjaVE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "falconpy" ];

  meta = {
    description = "CrowdStrike Falcon SDK for Python";
    homepage = "https://github.com/CrowdStrike/falconpy";
    changelog = "https://github.com/CrowdStrike/falconpy/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
