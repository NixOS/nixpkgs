{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-amVF5iYtDtNSLhPFFXE3GHl+N+2MZywxrXsknzcu8Qg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "geographiclib" ];

  meta = {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
