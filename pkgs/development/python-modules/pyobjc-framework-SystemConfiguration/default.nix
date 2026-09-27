{
  buildPythonPackage,
  darwin,
  lib,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  setuptools,
  unittestCheckHook,
}:

let
  osImport = "import os";
  dhcpInfoTest = "class TestSCDynamicStoreCopyDHCPInfo(TestCase):";
in
buildPythonPackage rec {
  pname = "pyobjc-framework-SystemConfiguration";
  pyproject = true;
  __structuredAttrs = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${src.name}/pyobjc-framework-SystemConfiguration";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [ darwin.DarwinTools ];

  nativeCheckInputs = [ unittestCheckHook ];

  # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
  # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
  postPatch = ''
    substituteInPlace pyobjc_setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion" \
      --replace-fail "/usr/bin/" ""

    substituteInPlace PyObjCTest/test_scdynamicstorecopydhcpinfo.py \
      --replace-fail '${osImport}' '${osImport}
    import unittest' \
      --replace-fail '${dhcpInfoTest}' '@unittest.skip("requires a host DHCP lease")
    ${dhcpInfoTest}'
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
}
