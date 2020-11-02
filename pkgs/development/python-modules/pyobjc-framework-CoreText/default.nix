{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Quartz }:

buildPythonPackage rec {
  pname = "pyobjc-framework-CoreText";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d2x8200xfl7sv9vw5i62f49fhmgzhqaj5kjj0v7x0n2v4dxlkwl";
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
    pyobjc-framework-Quartz
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "CoreText" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework CoreText on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-CoreText/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
