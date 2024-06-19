{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ansi2image";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "ansi2image";
    rev = "refs/tags/v${version}";
    hash = "sha256-1sPEEWcOzesLQXSeMsUra8ZRSMAKzH6iisOgdhpxhKM=";
  };

  propagatedBuildInputs = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansi2image" ];

  pytestFlagsArray = [ "tests/tests.py" ];

  meta = with lib; {
    description = "Module to convert ANSI text to an image";
    mainProgram = "ansi2image";
    homepage = "https://github.com/helviojunior/ansi2image";
    changelog = "https://github.com/helviojunior/ansi2image/blob/${version}/CHANGELOG";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
