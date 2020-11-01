{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Accounts, pyobjc-framework-CoreData, pyobjc-framework-CoreLocation }:

buildPythonPackage rec {
  pname = "pyobjc-framework-CloudKit";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04wkzrfjm98k3b43fnb29gq412sshf1skm5kfg5h87zd19qka4rm";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Accounts
    pyobjc-framework-CoreData
    pyobjc-framework-CoreLocation
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
    description = "Wrappers for the framework CloudKit on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-CloudKit/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
