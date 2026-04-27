{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  luajit,
}:
buildPythonPackage (finalAttrs: {
  pname = "lupa";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scoder";
    repo = "lupa";
    tag = "lupa-${finalAttrs.version}";
    hash = "sha256-JlKxisVd0sbLcmVjzyFEkbUDAornAoCWekpASl6qeY4=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    LUPA_NO_BUNDLE = "true";
  };

  buildInputs = [
    luajit
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
