{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "falconpy";
  version = "1.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CrowdStrike";
    repo = "falconpy";
    tag = "v${version}";
    hash = "sha256-/ofAp4Hh+gj+2FSwQUI33OIo2iSBoOkbL9gB2F59YHw=";
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
