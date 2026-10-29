{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "leb128";
  version = "1.0.9";
  pyproject = true;

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X3iBYiANzM97M91dCyjEU/Onhqcid3MMsNzzKtcRcyA=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "leb128" ];

  meta = {
    changelog = "https://github.com/mohanson/leb128/releases/tag/${finalAttrs.src.tag}";
    description = "Utility to encode and decode Little Endian Base 128";
    homepage = "https://github.com/mohanson/leb128";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
