{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "noiseprotocol";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "plizonczyk";
    repo = "noiseprotocol";
    rev = "refs/tags/v${version}";
    hash = "sha256-VZkKNxeSxLhRDhrj4VKV/1eXl7RtcsnCHru5KC/OYNY=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "noise" ];

  meta = with lib; {
    description = "Noise Protocol Framework";
    homepage = "https://github.com/plizonczyk/noiseprotocol/";
    changelog = "https://github.com/plizonczyk/noiseprotocol/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
