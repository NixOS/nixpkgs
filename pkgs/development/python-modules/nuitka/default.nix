{ lib, stdenv
, buildPythonPackage
, fetchurl
, vmprof
, pyqt4
, isPyPy
, pkgs
}:

let
  # scons is needed but using it requires Python 2.7
  # Therefore we create a separate env for it.
  scons = pkgs.python27.withPackages(ps: [ pkgs.scons ]);
in buildPythonPackage rec {
  version = "0.6.8.4";
  pname = "Nuitka";

  # Latest version is not yet on PyPi
  src = fetchurl {
    url = "https://github.com/kayhayen/Nuitka/archive/${version}.tar.gz";
    sha256 = "0awhwksnmqmbciimqmd11wygp7bnq57khcg4n9r4ld53s147rmqm";
  };

  checkInputs = [ vmprof pyqt4 ];
  nativeBuildInputs = [ scons ];

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
