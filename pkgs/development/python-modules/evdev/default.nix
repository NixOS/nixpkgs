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
  version = "1.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LBQOAayEN3WPoj/lyHE5dBJGH0LUIaogJB3I/oz8y8k=";
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
