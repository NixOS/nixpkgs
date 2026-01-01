{
  lib,
  asyncssh,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
<<<<<<< HEAD
  version = "1.5.4";
=======
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "aioasuswrt";
<<<<<<< HEAD
    tag = "V${version}";
    hash = "sha256-tsvtOe3EX/Z7g6Z0MM2npYOTEJoKV9wUbhkhcROILxE=";
=======
    tag = "v${version}";
    hash = "sha256-4bVDho1JtNoWW3ueDgfu+GfRtrxWP6XxIK5R3BXgqfQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ asyncssh ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioasuswrt" ];

<<<<<<< HEAD
  meta = {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    changelog = "https://github.com/kennedyshead/aioasuswrt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    changelog = "https://github.com/kennedyshead/aioasuswrt/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
