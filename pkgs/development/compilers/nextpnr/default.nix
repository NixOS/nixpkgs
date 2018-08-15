{ stdenv, fetchFromGitHub, cmake
, icestorm, python3, boost, qtbase
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2018.08.09";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "2e02f2d6166c75b1fcec73d268e97e407071a372";
    sha256 = "1f98mkailn75gz5fvhjhnyr0gwa0r8mm3f2sbvgl0yvys8qi08wr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boostPython python3 qtbase ];

  enableParallelBuilding = true;
  cmakeFlags =
    [ "-DARCH=generic;ice40"
      "-DICEBOX_ROOT=${icestorm}/share/icebox"
    ];

  meta = with stdenv.lib; {
    description = "Place and route tool for FPGAs";
    homepage    = https://github.com/yosyshq/nextpnr;
    license     = licenses.isc;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
