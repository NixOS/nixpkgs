{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core }:

buildPythonPackage rec {
  pname = "pyobjc-framework-ExternalAccessory";
  version = "6.2.2";

  disabled = pythonOlder "3.6" ||
    (stdenv.lib.versionOlder "${darwin.apple_sdk.sdk.version}" "10.14") && throw "${pname}: requires apple_sdk.sdk 10.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v1zsvhawz2bsi5wz31q0h3jxd74g94rnmxhr1vx5dj09ksr67ks";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    ExternalAccessory
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
    description = "Wrappers for the framework ExternalAccessory on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-ExternalAccessory/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
