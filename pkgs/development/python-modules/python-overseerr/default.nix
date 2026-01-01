{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-overseerr";
<<<<<<< HEAD
  version = "0.8.0";
  pyproject = true;

=======
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-overseerr";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-izgUTgRG63FUjb8mH1W4yXFRvwPWIWPKsSiY9awq9SM=";
=======
    hash = "sha256-J0n3uMZaSWcnf3c1d4wdg+OgB9wPE2i/835M6Z3fMPw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "python_overseerr" ];

  meta = {
    description = "Client for Overseerr";
    homepage = "https://github.com/joostlek/python-overseerr";
<<<<<<< HEAD
    changelog = "https://github.com/joostlek/python-overseerr/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/joostlek/python-overseerr/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
