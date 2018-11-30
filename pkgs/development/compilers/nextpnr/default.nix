{ stdenv, fetchFromGitHub, cmake
, icestorm, python3, boost, qtbase
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2018.10.17";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "529a595157a2eef24f8529b0de0c504a40ed503b";
    sha256 = "06yp89rpvb2s4zc1qkbcp76kqwkk9s8j2ckblqw547dy5ah2cl7h";
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
