{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, mbelib
, serialdv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsdcc";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "dsdcc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DMCk29O2Lmt2tjo6j5e4ZdZeDL3ZFUh66Sm6TGrIaeU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mbelib
    serialdv
  ];

  cmakeFlags = [
    "-DUSE_MBELIB=ON"
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libdsdcc.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = {
    description = "Digital Speech Decoder (DSD) rewritten as a C++ library";
    homepage = "https://github.com/f4exb/dsdcc";
    license = lib.licenses.gpl3;
    mainProgram = "dsdccx";
    maintainers = with lib.maintainers; [ alexwinter ];
    platforms = lib.platforms.unix;
  };
})
