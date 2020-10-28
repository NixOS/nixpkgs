{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, python,
pyobjc-core, pyobjc-framework-FSEvents }:

buildPythonPackage rec {
  pname = "pyobjc-framework-CoreServices";
  version = "6.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2sw69zk61wfmwqkmd74agzp3j92gn0fsl5h2i8a4slm5pi1hq0";
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
  ]));

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-FSEvents
  ];

  # clang-7: error: argument unused during compilation: '-fno-strict-overflow'
  hardeningDisable = [ "strictoverflow" ];

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc-framework-CoreServices" ];

  meta = with stdenv.lib; {
    description = "Wrappers for the framework CoreServices on Mac OS X";
    homepage = "https://pythonhosted.org/pyobjc-framework-CoreServices/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
