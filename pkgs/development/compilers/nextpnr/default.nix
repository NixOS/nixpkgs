{ stdenv, fetchFromGitHub, cmake
, icestorm, python3, boost, qtbase
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2019.01.08";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "c1d15c749c2aa105ee7b38ebe1b60a27e3743e8c";
    sha256 = "082ac03s6164s7dwz1l9phshl8m1lizn45jykabrhks5jcccchbh";
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
