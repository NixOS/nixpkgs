{
  buildPythonPackage,
  darwin,
  lib,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjc-framework-libdispatch";
  pyproject = true;
  __structuredAttrs = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${finalAttrs.src.name}/pyobjc-framework-libdispatch";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  patches = [ ../pyobjc-core/use-PATH-for-macOS-tools.patch ];

  dependencies = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [
    "dispatch"
    "libdispatch"
  ];

  meta = {
    description = "PyObjC wrappers for the libdispatch framework on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-framework-libdispatch";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
