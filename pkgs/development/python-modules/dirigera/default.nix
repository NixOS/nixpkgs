{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "dirigera";
<<<<<<< HEAD
  version = "1.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Leggin";
    repo = "dirigera";
    tag = version;
=======
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Leggin";
    repo = "dirigera";
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-xFiAhlNbl20MPFNkl8J4vx+KgvINYS3P5EAQxc620/k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
    websocket-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dirigera" ];

<<<<<<< HEAD
  meta = {
    description = "Module for controlling the IKEA Dirigera Smart Home Hub";
    homepage = "https://github.com/Leggin/dirigera";
    changelog = "https://github.com/Leggin/dirigera/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "generate-token";
=======
  meta = with lib; {
    description = "Module for controlling the IKEA Dirigera Smart Home Hub";
    homepage = "https://github.com/Leggin/dirigera";
    changelog = "https://github.com/Leggin/dirigera/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "generate-token";
    broken = versionOlder pydantic.version "2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
