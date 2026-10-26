{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "metar";
  version = "1.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZDjlXcSTUcSP7oRdhzLpXf/fLUA7Nkc6nj2I6vovbHg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "metar" ];

  meta = {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    changelog = "https://github.com/python-metar/python-metar/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd1;
    maintainers = with lib.maintainers; [ fab ];
  };
})
