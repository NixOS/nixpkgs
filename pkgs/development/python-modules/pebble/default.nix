{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pebble";
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noxdafox";
    repo = "pebble";
    tag = finalAttrs.version;
    hash = "sha256-B2TFhBA0TgN+maqH+eELR2tdGUoPq1t31t2NM+K22vQ=";
  };

  patches = [
    # Fix cvise regression: https://github.com/noxdafox/pebble/issues/164
    (fetchpatch {
      name = "fix-mutex.patch";
      url = "https://github.com/noxdafox/pebble/commit/711c98f4193f4006f699e3d245d6855385eb267e.patch";
      hash = "sha256-dCoOvCv1r9YKSsoKyyZ9rXLNhVmopWnXglBrO5be1Bw=";
    })
  ];

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
