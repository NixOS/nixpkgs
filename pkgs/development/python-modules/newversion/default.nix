{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "newversion";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "newversion";
    tag = version;
    hash = "sha256-R26yZQnQN/+e8XD3YKl+3bJKGnZaVzOVoTlGHOyratg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "newversion" ];

<<<<<<< HEAD
  meta = {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    changelog = "https://github.com/vemel/newversion/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    changelog = "https://github.com/vemel/newversion/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "newversion";
  };
}
