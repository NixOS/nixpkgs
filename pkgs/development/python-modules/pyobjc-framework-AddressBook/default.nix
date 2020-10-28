{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa }:

buildPythonPackage rec {
  pname = "pyobjc-framework-AddressBook";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w1mx64f8hqz20kwp8jsk80qglzsf3408g9cidkmnin09bf11x6n";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = [
  ] ++ (with darwin; [
  ] ++ (with apple_sdk.frameworks;[
    AddressBook
    Foundation
  ]));

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  # show test names instead of just dots
  setuptoolsCheckFlagsArray = [ "--verbosity=3" ];

  preCheck = ''
    # testConstants in PyObjCTest.test_cfsocket.TestSocket returns: Segmentation fault: 11
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    # Test removed because it requires network:
    # an error occurred while attempting to obtain endpoint for listener 'HostCallsAuxiliary': Connection interrupted
    rm PyObjCTest/test_abpersonview.py

    # Test removed because it likely requires network:
    # AssertionError: None is not an instance of <objective-c class ABAddressBook at 0x7fff96826300>
    rm PyObjCTest/test_abaddressbookc.py

    # Set correct SDK version
    substituteInPlace PyObjCTest/test_abglobals.py \
      --replace 'def testConstants_10_7_broken(self):' 'def disabled_testConstants_10_7_broken(self):'
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework AddressBook on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-AddressBook/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
