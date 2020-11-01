{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa, pyobjc-framework-Quartz }:

buildPythonPackage rec {
  pname = "pyobjc-framework-SceneKit";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fxkgi55jrnnqc94x7qghwbg652gkshgjml54ir9kai0ca3ab85h";
  };

  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    SceneKit
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Cocoa
    pyobjc-framework-Quartz
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "SceneKit" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework SceneKit on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-SceneKit/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
