{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, mbelib, serialdv
}:

stdenv.mkDerivation rec {
  pname = "dsdcc";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "dsdcc";
    rev = "v${version}";
    sha256 = "sha256-EsjmU0LQOXnOoTFrnn63hAbvqbE6NVlSQTngot5Zuf4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ mbelib serialdv ];

  cmakeFlags = [
    "-DUSE_MBELIB=ON"
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libdsdcc.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = with lib; {
    description = "Digital Speech Decoder (DSD) rewritten as a C++ library";
    homepage = "https://github.com/f4exb/dsdcc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.unix;
  };
}
