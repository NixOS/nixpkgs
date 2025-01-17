{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonpickle,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koalalorenzo";
    repo = "python-digitalocean";
    tag = "v${version}";
    hash = "sha256-CIYW6vl+IOO94VyfgTjJ3T13uGtz4BdKyVmE44maoLA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonpickle
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  preCheck = ''
    cd digitalocean
  '';

  # Test tries to access the network
  disabledTests = [ "TestFirewall" ];

  pythonImportsCheck = [ "digitalocean" ];

  meta = with lib; {
    description = "Python API to manage Digital Ocean Droplets and Images";
    homepage = "https://github.com/koalalorenzo/python-digitalocean";
    changelog = "https://github.com/koalalorenzo/python-digitalocean/releases/tag/v${version}";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ teh ];
  };
}
