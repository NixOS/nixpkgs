{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyunormalize";
  version = "16.0.0";
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lh37tKEYFUrib3BxBCalKjZLkmyRkfdkYB9ajLEnYfc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The pypi archive does not contain the tests.
  # NOTE: one should review this for each future update.
  doCheck = false;

  pythonImportsCheck = [ "pyunormalize" ];

  meta = {
    description = "Unicode normalization forms (NFC, NFKC, NFD, NFKD) independent of the Python core Unicode database";
    homepage = "https://github.com/mlodewijck/pyunormalize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
