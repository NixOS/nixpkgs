{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  morphys,
  pytestCheckHook,
  python-baseconv,
  setuptools,
  six,
}:
buildPythonPackage (finalAttrs: {
  pname = "py-multibase";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multibase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k5vQqrSe1glT2YIcD+FIhQTpCZQvx5D4z1n7omuypcI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    morphys
    python-baseconv
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multibase" ];

  meta = {
    description = "Module for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    changelog = "https://github.com/multiformats/py-multibase/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
