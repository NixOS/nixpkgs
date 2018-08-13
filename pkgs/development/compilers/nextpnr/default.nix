{stdenv, fetchFromGitHub, cmake
, withPython ? true, python3Packages
, withGui ? true, qt5
, families ? [ "ice40" ], icestorm
}:

with stdenv.lib;

let depIce40 = elem "ice40" families;
in
assert withPython -> python3Packages != null && versionAtLeast python3Packages.python.version "3.5";
assert withGui -> withPython && qt5 != null;
assert depIce40 -> icestorm != null;

stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2018.08.11";
  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "nextpnr";
    rev    = "2e02f2d6166c75b1fcec73d268e97e407071a372";
    sha256 = "1f98mkailn75gz5fvhjhnyr0gwa0r8mm3f2sbvgl0yvys8qi08wr";
  };

  nativeBuildInputs = [ cmake python3Packages.python3 qt5.qttools ];
  buildInputs = [
    python3Packages.boost
    qt5.qtbase
    qt5.qtx11extras
  ];

  cmakeFlags =
  [ ("-DARCH=" + (concatStringsSep ":" families)) ]
  ++ (optional (!withGui) "-DBUILD_GUI=OFF")
  ++ (optional (!withPython) "-DBUILD_PYTHON=OFF")
  ++ (optional depIce40 "-DICEBOX_ROOT=${icestorm}/share/icebox");

  enableParallelBuilding = true;

  meta = {
    description = "FPGA place and route tool";
    longDescription = ''
      nextpnr aims to be a vendor neutral, timing driven,
      FOSS FPGA place and route tool. Currently nextpnr
      supports ice40, ecp5(experimental) and a generic
      backend(experimental) for user-defined architectures.
    '';
    homepage = https://github.com/YosysHQ/nextpnr;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ jpathy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
