{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-Cocoa }:

buildPythonPackage rec {
  pname = "pyobjc-framework-ImageCaptureCore";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y621hv382n08v1jckh87h61adv4i61wqbsh2z75454ln4gijh3m";
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
    ImageCaptureCore
  ]));

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-ImageCaptureCore" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework ImageCaptureCore on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-ImageCaptureCore/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
