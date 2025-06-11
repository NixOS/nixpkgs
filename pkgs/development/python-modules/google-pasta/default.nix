{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "google-pasta";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yfLI38j5bQ1YCCmZIHIb4wye7DfyOJ8okE9FRWXIoW4=";
  };

  postPatch = ''
    substituteInPlace pasta/augment/inline_test.py \
      --replace-fail assertRaisesRegexp assertRaisesRegex
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pasta" ];

  meta = {
    description = "AST-based Python refactoring library";
    homepage = "https://github.com/google/pasta";
    changelog = "https://github.com/google/pasta/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timokau ];
  };
}
