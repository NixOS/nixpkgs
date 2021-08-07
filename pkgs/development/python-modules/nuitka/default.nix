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
  version = "0.6.14.5";
  pname = "Nuitka";

  # Latest version is not yet on PyPi
  src = fetchFromGitHub {
    owner = "kayhayen";
    repo = "Nuitka";
    rev = version;
    sha256 = "08kcp22zdgp25kk4bp56z196mn6bdi3z4x0q2y9vyz0ywfzp9zap";
  };

  checkInputs = [ vmprof pyqt4 ];
  nativeBuildInputs = [ scons ];
  propagatedBuildInputs = [ chrpath ];

  postPatch = ''
    patchShebangs tests/run-tests
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace nuitka/plugins/standard/ImplicitImports.py --replace 'locateDLL("uuid")' '"${pkgs.util-linux.out}/lib/libuuid.so"'
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
