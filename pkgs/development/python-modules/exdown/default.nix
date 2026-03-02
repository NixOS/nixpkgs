{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "exdown";
  version = "0.9.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-+IN+0P4SljUWxF01Ln9PgeFVA/+qGKFVoKMGluAuYDw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "exdown" ];

  meta = {
    description = "Extract code blocks from markdown";
    homepage = "https://github.com/nschloe/exdown";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
