{ lib, stdenv, fetchFromGitHub, cmake, libxml2, libxslt, python3, qt4 }:

# This derivation does not provide any Python module and should therefore be called via `all-packages.nix`.
let
  pythonEnv = python3.withPackages (ps: with ps; [ sphinx ]);
in
stdenv.mkDerivation rec {
  pname = "pyside-apiextractor";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "Apiextractor";
    rev = version;
    sha256 = "sha256-YH8aYyzv59xiIglZbdNgOPnmEQwNE2GmotAFFfFdMlg=";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$dev")
  '';

  nativeBuildInputs = [ cmake pythonEnv ];
  buildInputs = [ qt4 libxml2 libxslt ];

  meta = with lib; {
    description = "Eases the development of bindings of Qt-based libraries for high level languages by automating most of the process";
    license = licenses.gpl2;
    homepage = "http://www.pyside.org/docs/apiextractor/";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
