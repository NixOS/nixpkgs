{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfibaro";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rappenze";
    repo = "pyfibaro";
    tag = finalAttrs.version;
    hash = "sha256-9BBlnro7PcalTNs1VN/9ECL77YtxvxAV67d87Mu7akY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pyfibaro" ];

  meta = {
    description = "Library to access FIBARO Home center";
    homepage = "https://github.com/rappenze/pyfibaro";
    changelog = "https://github.com/rappenze/pyfibaro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
