{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, vmprof
, isPyPy
, pkgs
, scons
, chrpath
}:

buildPythonPackage rec {
  pname = "nuitka";
  version = "1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-SsRvgyV5FKe3MuNMACT8WVB51cYxgNjAT9IjvOOI1LA=";
  };

  nativeCheckInputs = [ vmprof ];
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
