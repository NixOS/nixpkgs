{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core }:

buildPythonPackage rec {
  pname = "pyobjc-framework-OSLog";
  version = "6.2.2";

  disabled = pythonOlder "3.6" ||
    (stdenv.lib.versionOlder "${darwin.apple_sdk.sdk.version}" "10.13") && throw "${pname}: requires apple_sdk.sdk 10.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11z4gzs7clrqljyfg1pd043q324azpqzjylkkh4c04v9zfyhajsp";
  };

  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    OSLog
  ];

  propagatedBuildInputs = [
    pyobjc-core
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  # show test names instead of just dots
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} setup.py test --verbosity=3

    runHook postCheck
  '';

  preCheck = ''
    # testConstants in PyObjCTest.test_cfsocket.TestSocket returns: Segmentation fault: 11
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework OSLog on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-OSLog/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
