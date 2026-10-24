{
  buildPythonPackage,
  setuptools,
  darwin,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjc-framework-CoreAudio";
  pyproject = true;
  __structuredAttrs = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${finalAttrs.src.name}/pyobjc-framework-CoreAudio";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
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
    "CoreAudio"
    "PyObjCTools"
  ];

  meta = {
    description = "Wrappers for the framework CoreAudio on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
})
