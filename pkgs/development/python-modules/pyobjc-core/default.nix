{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, cffi, setuptools }:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z42b8nrgfa2wfxds5pwc0j8iysjkqi7i2xj33fxlf940idb3rrq";
  };

  patchPhase = ''
    # Hard code correct SDK version
    substituteInPlace setup.py \
      --replace 'get_sdk_level(self.sdk_root)' '"${darwin.apple_sdk.sdk.version}"'

    # Hard code OS version
    # This needs to be done here or pyobjc-frameworks-* don't get the change
    substituteInPlace Lib/PyObjCTools/TestSupport.py \
      --replace 'return ".".join(v.split("."))' 'return "${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = [
    cffi
  ] ++ (with darwin.apple_sdk.frameworks;[
    Carbon
    Cocoa
    CoreFoundation
  ]);

  propagatedBuildInputs = with darwin;[
    objc4
  ] ++ [
    # required for namespaced import of PyObjCTools.TestSupport from pyobjc-framework-*
    setuptools
  ];

  hardeningDisable = [ "strictoverflow" ];

  preCheck = ''
    # Test removed because ~ does not expand to /homeless-shelter
    rm PyObjCTest/test_bundleFunctions.py

    # xcrun is not available and nix paths do not match the hardcoded paths
    # https://github.com/ronaldoussoren/pyobjc/blob/efecb479c3cf32ec1d36abfb9b7d7c8cfd4ede6d/pyobjc-core/PyObjCTest/test_dyld.py#L207
    substituteInPlace PyObjCTest/test_dyld.py \
      --replace 'p = subprocess.check_output(["xcrun", "--show-sdk-path"]).strip()' 'return True'

    # Tests in PyObjCTest/test_bridgesupport.py return "unexpected success" for CoreAudio.bridgesupport and MetalPerformanceShaders
    # removing them from BROKEN_FRAMEWORKS does no work and leads to:
    #   objc.internal_error: Invalid array definition in type signature: [
    rm PyObjCTest/test_bridgesupport.py

    substituteInPlace PyObjCTest/test_testsupport.py \
      --replace '".".join(platform.mac_ver()[0].split("."))' '"${darwin.apple_sdk.sdk.version}"'
  '';

  # show test names instead of just dots
  setuptoolsCheckFlagsArray = [ "--verbosity=3" ];

  meta = with stdenv.lib;
    {
      description = "Python<->ObjC Interoperability Module";
      homepage = "https://pythonhosted.org/pyobjc-core/";
      license = licenses.mit;
      maintainers = with maintainers; [ SuperSandro2000 ];
      platforms = platforms.darwin;
    };
}
