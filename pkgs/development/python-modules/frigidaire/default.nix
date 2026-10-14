{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "frigidaire";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = "frigidaire";
    tag = finalAttrs.version;
    hash = "sha256-1Zl97UynwI0vkt6rDEmqh1R8G493f9C3zYn1KLfFjjs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version = "0.0.0-dev"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "frigidaire" ];

  meta = {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
