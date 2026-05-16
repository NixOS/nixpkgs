{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dtfabric";
  version = "20260411";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0hnJJ76wpINsNXecrGCQILqixo4xUhH8dW6djq9/vH4=";
  };

  pythonRemoveDeps = [ "pip" ];

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} run_tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "dtfabric" ];

  meta = {
    description = "Project to manage data types and structures, as used in the libyal projects";
    changelog = "https://github.com/libyal/dtfabric/releases/tag/${finalAttrs.version}";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    homepage = "https://github.com/libyal/dtfabric";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jayrovacsek ];
  };
})
