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
  version = "20230520";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rJPBEe/eAQ7OPPZHeFbomkb8ca3WTheDhs/ic6GohVM=";
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
