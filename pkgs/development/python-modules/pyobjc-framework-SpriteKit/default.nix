{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Quartz }:

buildPythonPackage rec {
  pname = "pyobjc-framework-SpriteKit";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sqyr7szv0s0fv8hxasa00a311i90s8zsjsa6nxnz41vpcrws8sm";
  };

  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    SpriteKit
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Quartz
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-SpriteKit" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework SpriteKit on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-SpriteKit/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
