{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  matplotlib,
  palettable,
  pandas,
  scipy,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mizani";
  version = "0.14.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbBHgfcyyK5hCjeILgvl03+uWsOJwLF55UKecd8g4Y0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mizani" ];

  meta = {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
