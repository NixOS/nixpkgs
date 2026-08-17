{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "brottsplatskartan";
  version = "1.0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrillux";
    repo = "brottsplatskartan";
    tag = finalAttrs.version;
    hash = "sha256-Sc8g8Pqc1ddDlkuAhSpfP4rByGPM+SGkKYHfDZmtPB4=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "brottsplatskartan" ];

  meta = {
    description = "Python API wrapper for brottsplatskartan.se";
    homepage = "https://github.com/chrillux/brottsplatskartan";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
