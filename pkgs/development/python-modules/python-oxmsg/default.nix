{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  olefile,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-oxmsg";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scanny";
    repo = "python-oxmsg";
    tag = "v${version}";
    hash = "sha256-ramM27+SylBeJyb3kkRm1xn3qAefiLuBOvI/iucK2wM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    olefile
    typing-extensions
  ];

  pythonImportsCheck = [ "oxmsg" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/scanny/python-oxmsg/blob/${src.tag}/CHANGELOG.md";
    description = "Extract attachments from Outlook .msg files";
    homepage = "https://github.com/scanny/python-oxmsg";
    license = lib.licenses.mit;
    mainProgram = "oxmsg";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
