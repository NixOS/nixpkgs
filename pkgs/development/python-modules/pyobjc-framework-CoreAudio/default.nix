{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa }:

buildPythonPackage rec {
  pname = "pyobjc-framework-CoreAudio";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "016sgcp6r9y17gzmi0qyvcfwkhrhhf8wmlvnbg3kdr2rxpi9n9d9";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
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
  '';

  meta = with stdenv.lib; {
    description = "Wrappers for the framework CoreAudio on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-CoreAudio/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
