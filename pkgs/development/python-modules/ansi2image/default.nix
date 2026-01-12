{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ansi2image";
  version = "0.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "ansi2image";
    tag = "v${version}";
    hash = "sha256-1sPEEWcOzesLQXSeMsUra8ZRSMAKzH6iisOgdhpxhKM=";
  };

  propagatedBuildInputs = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansi2image" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Module to convert ANSI text to an image";
    mainProgram = "ansi2image";
    homepage = "https://github.com/helviojunior/ansi2image";
    changelog = "https://github.com/helviojunior/ansi2image/blob/${version}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
