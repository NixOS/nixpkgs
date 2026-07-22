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

buildPythonPackage rec {
  pname = "pyobjc-framework-ApplicationServices";
  pyproject = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${src.name}/pyobjc-framework-ApplicationServices";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  # Same workaround as pyobjc-framework-Quartz; see
  # https://github.com/ronaldoussoren/pyobjc/pull/641.
  postPatch = ''
    substituteInPlace pyobjc_setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion" \
      --replace-fail "/usr/bin/sw_vers" "sw_vers" \
      --replace-fail "/usr/bin/xcrun" "xcrun"
  '';

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
}
