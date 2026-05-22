{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyserial";
  version = "3.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PHfgFBcN//vYFub/wgXphC77EL6fWOwW0+hnW0klzds=";
  };

  patches = [
    ./001-rfc2217-only-negotiate-on-value-change.patch
    ./002-rfc2217-timeout-setter-for-rfc2217.patch
  ];

  build-system = [ setuptools ];

  doCheck = !stdenv.hostPlatform.isDarwin; # broken on darwin

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [ "serial" ];

  meta = {
    description = "Python serial port extension";
    homepage = "https://github.com/pyserial/pyserial";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
