{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2025.4.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = "html2text";
    tag = version;
    hash = "sha256-SMdILvCVXMe3Tlf3kK54VfEKsQ/KvpBZK3xZ4zVwcfo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html2text" ];

  meta = with lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = "https://github.com/Alir3z4/html2text/";
    changelog = "https://github.com/Alir3z4/html2text/blob/${src.tag}/ChangeLog.rst";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "html2text";
  };
}
