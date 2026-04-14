{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pyyaml,
  setuptools,
}:
buildPythonPackage rec {
  pname = "dtfabric";
  version = "20260411";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0hnJJ76wpINsNXecrGCQILqixo4xUhH8dW6djq9/vH4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
  ];

  pythonRemoveDeps = [
    "pip"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/libyal/dtfabric/releases/tag/${version}";
    description = "Project to manage data types and structures, as used in the libyal projects";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    homepage = "https://github.com/libyal/dtfabric";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jayrovacsek ];
  };
}
