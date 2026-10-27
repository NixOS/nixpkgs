{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  pkg-config,
  augeas,
  cffi,
  pkgs, # for libxml2
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "python-augeas";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hercules-team";
    repo = "python-augeas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lq8ckra3sqN38zo1d5JsEq6U5TtLKRmqysoWNwR9J9A=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    augeas
    pkgs.libxml2
  ];

  dependencies = [ cffi ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "augeas" ];

  meta = {
    changelog = "https://github.com/hercules-team/python-augeas/releases/tag/v${finalAttrs.version}";
    description = "Pure python bindings for augeas";
    homepage = "https://github.com/hercules-team/python-augeas";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
