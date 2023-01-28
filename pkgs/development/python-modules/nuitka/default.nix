{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, vmprof
, pyqt4
, isPyPy
, pkgs
, scons
, chrpath
}:

buildPythonPackage rec {
  version = "1.1.5";
  pname = "Nuitka";

  # Latest version is not yet on PyPi
  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    sha256 = "0wgcl860acbxnq8q9hck147yhxz8pcbqhv9glracfnrsd2qkpgpp";
  };

  nativeCheckInputs = [ vmprof pyqt4 ];
  nativeBuildInputs = [ scons ];
  propagatedBuildInputs = [ chrpath ];

  postPatch = ''
    patchShebangs tests/run-tests
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace nuitka/plugins/standard/ImplicitImports.py --replace 'locateDLL("uuid")' '"${lib.getLib pkgs.util-linux}/lib/libuuid.so"'
  '';

  # We do not want any wrappers here.
  postFixup = "";

  checkPhase = ''
    tests/run-tests
  '';

  # Problem with a subprocess (parts)
  doCheck = false;

  # Requires CPython
  disabled = isPyPy;

  meta = with lib; {
    description = "Python compiler with full language support and CPython compatibility";
    license = licenses.asl20;
    homepage = "https://nuitka.net/";
  };

}
