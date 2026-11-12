{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "herepy";
  version = "3.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abdullahselek";
    repo = "HerePy";
    tag = version;
    hash = "sha256-JJUfQClB4gExxqNfL8u//HCvnO049hm8n3zuRnB0sBE=";
  };

  build-system = [ hatchling ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "herepy" ];

  meta = {
    changelog = "https://github.com/abdullahselek/HerePy/releases/tag/${version}";
    description = "Library that provides a Python interface to the HERE APIs";
    homepage = "https://github.com/abdullahselek/HerePy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
