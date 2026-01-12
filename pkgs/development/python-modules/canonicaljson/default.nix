{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4v2u8df63F2ctZvT0NQbBk3dppeAmsQyXc7XIdEvET8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ simplejson ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "canonicaljson" ];

  meta = {
    description = "Encodes objects and arrays as RFC 7159 JSON";
    homepage = "https://github.com/matrix-org/python-canonicaljson";
    changelog = "https://github.com/matrix-org/python-canonicaljson/blob/v${version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
