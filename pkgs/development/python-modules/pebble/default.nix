{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pebble";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noxdafox";
    repo = "pebble";
    tag = finalAttrs.version;
    hash = "sha256-U6siydeKf/Ekqq2qHZj/ro2VQix2dRaP80d5CPQnRKU=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "pebble" ];

  meta = {
    description = "API to manage threads and processes within an application";
    homepage = "https://github.com/noxdafox/pebble";
    changelog = "https://github.com/noxdafox/pebble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})
