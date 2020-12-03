{ stdenv
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
  version = "3.3.2";
  pname = "ovito";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = pname;
    rev = "v${version}";
    sha256 = "02mn3qmgyh72n77fj7h2plh5c1a9qx84m9cs7z18kkdzc93b6rr8";
  };

  buildInputs = [ cmake ffmpeg netcdf qscintilla zlib boost zlib git fftw hdf5 libssh qt5.qtbase qt5.qtsvg ];

  propagatedBuildInputs = with python.pkgs; [ sphinx numpy sip pyqt5 matplotlib ase ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Scientific visualization and analysis software for atomistic simulation data";
    homepage = "https://www.ovito.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ costrouc ];
    # ensures not built on hydra
    # https://github.com/NixOS/nixpkgs/pull/46846#issuecomment-436388048
    hydraPlatforms = [ ];
  };
}
