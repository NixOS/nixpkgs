{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-CoreServices }:

buildPythonPackage rec {
  pname = "pyobjc-framework-LaunchServices";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18pdbfbib9lgp7skplqr2hf3isywlq118j46i9dsmb8kl4baxhnr";
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
    pyobjc-framework-CoreServices
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
    description = "Wrappers for the framework LaunchServices on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-LaunchServices/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
