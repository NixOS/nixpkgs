{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ekey-bionyxpy";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "richardpolzer";
    repo = "ekey-bionyx-api";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-V4xYv+mjU4QO/+hOq3TH8b/X9PVP95i6apYkcqVDIWY=";
=======
    hash = "sha256-wKgIQp+E1fzOrp2Xx14RXvtxQMOb0rFkI55q2Rw+JNg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ekey_bionyxpy" ];

  meta = {
    description = "Interact with the bionyx third party API of the ekey biometric systems";
    homepage = "https://github.com/richardpolzer/ekey-bionyx-api";
    changelog = "https://github.com/richardpolzer/ekey-bionyx-api/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
