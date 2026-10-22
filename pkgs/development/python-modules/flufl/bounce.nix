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
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "flufl";
    repo = "flufl.bounce";
    tag = finalAttrs.version;
    hash = "sha256-ZbIwl6cSXVYqHOpfCyKSud9EC3+V1wqV0i8aCHf67tA=";
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
