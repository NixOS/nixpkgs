{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  lib,
}:

buildPythonPackage rec {
  pname = "leb128";
  version = "1.0.9";
  pyproject = true;

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    tag = "v${version}";
    hash = "sha256-X3iBYiANzM97M91dCyjEU/Onhqcid3MMsNzzKtcRcyA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "leb128" ];

  meta = {
    changelog = "https://github.com/mohanson/leb128/releases/tag/${src.tag}";
    description = "Utility to encode and decode Little Endian Base 128";
    homepage = "https://github.com/mohanson/leb128";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urlordjames ];
  };
}
