{
  buildPythonPackage,
  darwin,
  lib,
  pyobjc-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjc-framework-Cocoa";
  pyproject = true;
  __structuredAttr = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${finalAttrs.src.name}/pyobjc-framework-Cocoa";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  patches = [ ../pyobjc-core/use-PATH-for-macOS-tools.patch ];

  dependencies = [ pyobjc-core ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [
    "Cocoa"
    "CoreFoundation"
    "Foundation"
    "AppKit"
    "PyObjCTools"
  ];

  meta = {
    description = "PyObjC wrappers for the Cocoa frameworks on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-framework-Cocoa";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
