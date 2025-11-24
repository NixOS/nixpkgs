{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "portugueslab";
    repo = "arrayqueues";
    tag = "v${version}";
    hash = "sha256-tqIfpkwbJNd9jMe0YvAWz9Z8rOO80qxVM2ZcJFeAmwo=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arrayqueues" ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    changelog = "https://github.com/portugueslab/arrayqueues/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
