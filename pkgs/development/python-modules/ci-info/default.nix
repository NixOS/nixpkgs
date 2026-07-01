{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ci-info";
  version = "0.3.0";
  pyproject = true;

  __structuredAttrs = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-H9UMvUAfKa3/7rGLBIniMtFqwadFisa8MW3qtq5TX7A=";
  };

  nativeCheckInputs = [
    pytest
    pytestCheckHook
  ];

  doCheck = false; # both tests access network

  pythonImportsCheck = [ "ci_info" ];

  meta = {
    description = "Gather continuous integration information on the fly";
    homepage = "https://github.com/mgxd/ci-info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
