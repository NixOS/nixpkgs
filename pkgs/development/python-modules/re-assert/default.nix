{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  regex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "re-assert";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "re-assert";
    tag = "v${version}";
    hash = "sha256-UTXFTD3QOKIzjq05J9Ontv5h9aClOwlPYKFXfDnBWuc=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  pythonImportsCheck = [ "re_assert" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Show where your regex match assertion failed";
    license = lib.licenses.mit;
    homepage = "https://github.com/asottile/re-assert";
  };
}
