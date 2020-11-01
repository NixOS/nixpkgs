{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core }:

buildPythonPackage rec {
  pname = "pyobjc-framework-CoreSpotlight";
  version = "6.2.2";

  disabled = pythonOlder "3.6" ||
    (stdenv.lib.versionOlder "${darwin.apple_sdk.sdk.version}" "10.14") && throw "${pname}: requires apple_sdk.sdk 10.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ld1wahwkvj84l08y5bk7hjngd8af21ri1i3fkciw52afvdj33xv";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    CoreSpotlight
    Foundation
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
  '';

  preCheck = ''
    # testConstants in PyObjCTest.test_cfsocket.TestSocket returns: Segmentation fault: 11
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework CoreSpotlight on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-CoreSpotlight/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
