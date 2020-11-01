{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Quartz }:

buildPythonPackage rec {
  pname = "pyobjc-framework-LinkPresentation";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dcq0hfiq423f814hqar0xgqw3gpz9fvnkrd7pds21xwmrky209z";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = [
  ] ++ (with darwin; [
  ] ++ (with apple_sdk.frameworks;[
  ]));

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Quartz
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  # show test names instead of just dots
  setuptoolsCheckFlagsArray = [ "--verbosity=3" ];

  preCheck = ''
    # testConstants in PyObjCTest.test_cfsocket.TestSocket returns: Segmentation fault: 11
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework LinkPresentation on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-LinkPresentation/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
