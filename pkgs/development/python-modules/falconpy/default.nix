{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "falconpy";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CrowdStrike";
    repo = "falconpy";
    tag = "v${version}";
    hash = "sha256-yK6delBTDnK5cP8mWIQZRfZClRsM2IeqjqrqOjbrlnc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "falconpy" ];

  meta = {
    description = "The CrowdStrike Falcon SDK for Python";
    homepage = "https://github.com/CrowdStrike/falconpy";
    changelog = "https://github.com/CrowdStrike/falconpy/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
