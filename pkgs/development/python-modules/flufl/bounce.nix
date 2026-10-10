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
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "flufl";
    repo = "flufl.bounce";
    tag = finalAttrs.version;
    hash = "sha256-9Uy18NX6lPS+26a9sfI5+glK1NRl0rfSxORad+7YzTI=";
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
