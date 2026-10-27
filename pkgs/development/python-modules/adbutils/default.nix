{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  deprecation,
  retry2,
  pillow,
  pbr,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "adbutils";
  version = "2.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openatx";
    repo = "adbutils";
    tag = finalAttrs.version;
    hash = "sha256-zJz4fBekKOUeqBBfBPgGnHXVEKddelqReAQ2CEblObs=";
  };

  build-system = [
    setuptools
  ];

  env = {
    PBR_VERSION = finalAttrs.version;
  };

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = !stdenv.hostPlatform.isDarwin;

  dependencies = [
    pbr
    deprecation
    pillow
    requests
    retry2
  ];

  pythonImportsCheck = [ "adbutils" ];

  meta = {
    description = "Pure python adb library for google adb service";
    homepage = "https://github.com/openatx/adbutils";
    changelog = "https://github.com/openatx/adbutils/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dshatz ];
  };
})
