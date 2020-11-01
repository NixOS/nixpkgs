{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa, pyobjc-framework-DiscRecording }:

buildPythonPackage rec {
  pname = "pyobjc-framework-DiscRecordingUI";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zb8mbrdn66x8sw6idhyv56gl1zxpbl8f6f4axy7732kcqjld6jn";
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
    pyobjc-framework-Cocoa
    pyobjc-framework-DiscRecording
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-DiscRecordingUI" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework DiscRecordingUI on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-DiscRecordingUI/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
