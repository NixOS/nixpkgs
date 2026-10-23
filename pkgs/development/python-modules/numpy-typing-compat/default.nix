{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  numpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "numpy-typing-compat";
  version = "20260602.2.5";
  pyproject = true;

  src = fetchPypi {
    pname = "numpy_typing_compat";
    version = finalAttrs.version;
    hash = "sha256-GIWmeOmiRWSDntXRcRwAMXNft95/C17YjVUOXUWo1Pk=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "numpy_typing_compat"
  ];

  meta = {
    description = "Static typing compatibility layer for older versions of NumPy";
    homepage = "https://pypi.org/project/numpy-typing-compat/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tm-drtina ];
  };
})
