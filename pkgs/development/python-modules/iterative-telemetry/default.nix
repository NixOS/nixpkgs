{
  lib,
  appdirs,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  filelock,
  pytestCheckHook,
  pytest-mock,
  requests,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "iterative-telemetry";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "telemetry-python";
    tag = finalAttrs.version;
    hash = "sha256-+l9JH9MbN+Pai3MIcKZJObzoPGhQipfMd7T8v4SoSws=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    requests
    appdirs
    filelock
    distro
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "iterative_telemetry" ];

  meta = {
    description = "Common library to send usage telemetry";
    homepage = "https://github.com/iterative/iterative-telemetry";
    changelog = "https://github.com/iterative/iterative-telemetry/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
  };
})
