{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  aiohttp,
  tenacity,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
<<<<<<< HEAD
  version = "3.0.12";
=======
  version = "3.0.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-yJPORXU7hQ3TqSFZzyneQT4aAdrXqPmxnOwFQ665Vus=";
=======
    hash = "sha256-7mA4yyvNPKOGb6Ap7kjCLhR7G1E1CQqgWCtAhciCnR4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

<<<<<<< HEAD
=======
  pythonRelaxDeps = [
    "tenacity"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = {
    changelog = "https://gitlab.com/klikini/doorbirdpy/-/tags/${src.tag}";
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
