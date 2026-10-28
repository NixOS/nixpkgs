{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  atpublic,
  pytestCheckHook,
  sybil,
}:

buildPythonPackage (finalAttrs: {
  pname = "flufl-bounce";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "flufl";
    repo = "flufl.bounce";
    tag = finalAttrs.version;
    hash = "sha256-NWDh8vqHCAjhQYyOUkURuFhDa2xdtEukppCBCjhxhfg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    atpublic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sybil
  ];

  pythonImportsCheck = [ "flufl.bounce" ];

  pythonNamespaces = [ "flufl" ];

  meta = {
    description = "Email bounce detectors";
    homepage = "https://gitlab.com/warsaw/flufl.bounce";
    changelog = "https://gitlab.com/warsaw/flufl.bounce/-/blob/${finalAttrs.src.tag}/docs/NEWS.rst";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
})
