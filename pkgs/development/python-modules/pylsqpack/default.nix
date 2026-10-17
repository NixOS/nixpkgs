{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.24";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jsRV9EYUIo+J441AwbHjeJViDiDsayHjtWL6i3miOJA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
