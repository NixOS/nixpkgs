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
    rev = "refs/tags/${version}";
    hash = "sha256-R26yZQnQN/+e8XD3YKl+3bJKGnZaVzOVoTlGHOyratg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "newversion" ];

  meta = with lib; {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    changelog = "https://github.com/vemel/newversion/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "newversion";
  };
}
