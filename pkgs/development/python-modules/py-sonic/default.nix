{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-sonic";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "py_sonic";
    inherit (finalAttrs) version;
    hash = "sha256-3POR5A4viyQxVqdLzYIJ75sqKUgyKbpAA0g8K5t2rXg=";
  };

  build-system = [ setuptools ];

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "libsonic" ];

  meta = {
    description = "Python wrapper library for the Subsonic REST API";
    homepage = "https://github.com/crustymonkey/py-sonic";
    changelog = "https://github.com/crustymonkey/py-sonic/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wenngle ];
  };
})
