{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "libscrc";
  version = "1.8.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hex-in";
    repo = "libscrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SnjSermy6RCywOJ7uHe+1IfAUHPS2O/Eu4qaOWcaxLA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "libscrc" ];

  # TODO
  #nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Library for calculating CRC";
    homepage = "https://github.com/hex-in/libscrc";
    changelog = "https://github.com/hex-in/libscrc/blob/master/README.rst#notice";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
