{
  buildPythonPackage,
  fetchPypi,
  gitMinimal,
  lib,

  # build system
  poetry-core,
  setuptools,

  # dependencies
  typing-extensions,

  # test dependencies
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "codeowners";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "codeowners";
    inherit (finalAttrs) version;
    hash = "sha256-ZQVydXS2fbSDKj0NXkHA9+uA+IWO4nmW6FseBG+SZvg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" "poetry-core" \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "codeowners" ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/sbdchd/codeowners/blob/master/CHANGELOG.md";
    description = "Python library for codeowners files";
    homepage = "https://github.com/sbdchd/codeowners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
