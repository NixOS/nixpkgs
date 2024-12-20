{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "python-lorem";
  version = "1.3.0.post3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "python_lorem";
    hash = "sha256-Vw1TKheXg+AkhksnmWUfdIo+Jt7X7m1pS2f0Kfe8pv0=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lorem"
  ];

  meta = {
    description = "Pythonic lorem ipsum generator";
    homepage = "https://github.com/JarryShaw/lorem";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
