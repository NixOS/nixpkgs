{ lib, stdenv
, fetchFromGitLab
, cmake
, ffmpeg
, netcdf
, qscintilla
, zlib
, boost
, git
, fftw
, hdf5
, libssh
, qt5
, python
}:

stdenv.mkDerivation rec {
  version = "3.3.5";
  pname = "ovito";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = pname;
    rev = "v${version}";
    sha256 = "2tptLK0RU0afSFFE7uzL8bZ5j+nyRyh97ujJAHFh0wQ=";
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ ffmpeg netcdf qscintilla zlib boost zlib fftw hdf5 libssh qt5.qtbase qt5.qtsvg ];

  propagatedBuildInputs = with python.pkgs; [ sphinx numpy sip pyqt5 matplotlib ase ];

  meta = with lib; {
    description = "Scientific visualization and analysis software for atomistic simulation data";
    homepage = "https://www.ovito.org";
    license = with licenses; [ gpl3Only mit ];
    maintainers = with maintainers; [ costrouc ];
    # ensures not built on hydra
    # https://github.com/NixOS/nixpkgs/pull/46846#issuecomment-436388048
    hydraPlatforms = [ ];
  };
}
