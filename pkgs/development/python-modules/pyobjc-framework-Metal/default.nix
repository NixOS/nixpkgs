{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa }:

buildPythonPackage rec {
  pname = "pyobjc-framework-Metal";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s5jimym37nvmqz2jr8rb3h0kwakx0swwyadgi87kv5f0g0np4fa";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    Metal
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  # show test names instead of just dots
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} setup.py test --verbosity=3
  '';

  preCheck = ''
    # testConstants in PyObjCTest.test_cfsocket.TestSocket returns: Segmentation fault: 11
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    # Remove Test which is probably missing a sdk check
    # AttributeError: MTLSamplePositionMake
    substituteInPlace PyObjCTest/test_mtltypes.py \
      --replace 'v = Metal.MTLSamplePositionMake(0.5, 1.5)' "" \
      --replace 'self.assertIsInstance(v, Metal.MTLSamplePosition)' "" \
      --replace 'self.assertEqual(v, (0.5, 1.5))' ""

    # Remove Test which is probably missing a sdk check
    # AttributeError: MTLIndirectCommandBufferExecutionRangeMake
    substituteInPlace PyObjCTest/test_mtlindirectcommandbuffer.py \
      --replace 'def test_functions(self):' 'def disabled_test_functions(self):'
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework Metal on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-Metal/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
