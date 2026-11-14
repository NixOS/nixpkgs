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
  pname = "pyobjc-framework-SystemConfiguration";
  pyproject = true;
  __structuredAttrs = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${finalAttrs.src.name}/pyobjc-framework-SystemConfiguration";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [ darwin.DarwinTools ];

  nativeCheckInputs = [ unittestCheckHook ];

  # To be removed after the update lands:
  # https://github.com/NixOS/nixpkgs/pull/571501
  postPatch = ''
    substituteInPlace pyobjc_setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion" \
      --replace-fail "/usr/bin/" ""
  '';

  preCheck = ''
    rm PyObjCTest/test_scdynamicstorecopydhcpinfo.py
  '';

  dependencies = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev darwin.libffi}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [ "SystemConfiguration" ];

  meta = {
    description = "PyObjC wrappers for the SystemConfiguration framework on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    platforms = lib.platforms.darwin;
  };
})
