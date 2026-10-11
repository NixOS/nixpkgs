{
  buildPythonPackage,
  setuptools,
  darwin,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  pyobjc-framework-Quartz,
  pyobjc-framework-CoreText,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjc-framework-ApplicationServices";
  pyproject = true;
  __structuredAttrs = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${finalAttrs.src.name}/pyobjc-framework-ApplicationServices";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  patches = [ ../pyobjc-core/use-PATH-for-macOS-tools.patch ];

  dependencies = [
    pyobjc-core
    pyobjc-framework-Cocoa
    pyobjc-framework-Quartz
    pyobjc-framework-CoreText
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [
    "ApplicationServices"
    "HIServices"
  ];

  meta = {
    description = "PyObjC wrappers for the ApplicationServices framework on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ l1n ];
  };
})
