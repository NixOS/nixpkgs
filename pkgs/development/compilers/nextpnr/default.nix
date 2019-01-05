{ stdenv, fetchFromGitHub, cmake
, icestorm, python3, boost, qtbase
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2018.12.29";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "eb456ef476e8342b4709d71cbff6ef22a714d6ec";
    sha256 = "1gw9r8c6wyfhbzhm3hz1xpbq8ax27qnjwlrimzcykrr9r1cykiik";
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
