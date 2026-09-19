{
  lib,
  buildPythonPackage,
  fetchPypi,
  linuxHeaders,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "evdev";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RC+z9MjfyeYekBEzw1YiDALWY+yo80ci4M7N1jfrpQQ=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail /usr/include ${linuxHeaders}/include
  '';

  build-system = [ setuptools ];

  buildInputs = [ linuxHeaders ];

  pythonImportsCheck = [ "evdev" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tries to open /dev/uinput
    "tests/test_uinput.py"
  ];

  meta = {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = "https://python-evdev.readthedocs.io/";
    changelog = "https://github.com/gvalkov/python-evdev/blob/v${finalAttrs.version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
