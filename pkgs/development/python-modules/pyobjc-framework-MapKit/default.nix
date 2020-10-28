{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-CoreLocation, pyobjc-framework-Quartz }:

buildPythonPackage rec {
  pname = "pyobjc-framework-MapKit";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xs2sghk5blr60dak374fm1x6ivhk6g59mxjf6n2d4cvgkvylz1b";
  };
  
  postPatch = ''
    # Hard code correct SDK version
    substituteInPlace pyobjc_setup.py \
      --replace 'os.path.basename(data)[6:-4]' '"${darwin.apple_sdk.sdk.version}"'
  '';

  buildInputs = [
  ] ++ (with darwin; [
  ] ++ (with apple_sdk.frameworks;[
    Foundation
    MapKit
  ]));

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-CoreLocation
    pyobjc-framework-Quartz
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-MapKit" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework MapKit on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-MapKit/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
