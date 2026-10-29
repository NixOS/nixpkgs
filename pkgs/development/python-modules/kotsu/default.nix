{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "kotsu";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "datavaluepeople";
    repo = "kotsu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7bRrHowRKq3xiBiAkfS4ZL9PXHIUmZc99q9pHex9BLg=";
  };

  propagatedBuildInputs = [
    pandas
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    scikit-learn
  ];
  pythonImportsCheck = [ "kotsu" ];

  meta = {
    description = "Lightweight framework for structured and repeatable model validation";
    homepage = "https://github.com/datavaluepeople/kotsu";
    changelog = "https://github.com/datavaluepeople/kotsu/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
