{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa, pyobjc-framework-Metal }:

buildPythonPackage rec {
  pname = "pyobjc-framework-MetalKit";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ahj0d7q5pcbp83s35zpp2lym5p6mb03ah67kbgqvpv1kzjc4pw2";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    MetalKit
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Cocoa
    pyobjc-framework-Metal
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-MetalKit" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework MetalKit on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-MetalKit/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
