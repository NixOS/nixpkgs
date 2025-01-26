{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  pcre,
  libuv,
  portaudio,
  boost,
  zlib,
  python3,
  libffi,
  xorg,
  mesa,
  libGL,
}:

let
  llvm-patched = stdenv.mkDerivation {
    pname = "llvm";
    version = "3.8.0";

    src = fetchurl {
      url = "https://releases.llvm.org/3.8.0/llvm-3.8.0.src.tar.xz";
      hash = "sha256-VVsCjp7g9kRf+PlJ6hDpzYvg0ISEDiH7vh0x1R/AbkY=";
    };

    patches = [ ./llvm-3.8.0-extempore.patch ];
    patchFlags = [ "-p0" ];

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
    ];
    buildInputs = [
      zlib
      libffi
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_BUILD_LLVM_DYLIB=ON"
      "-DPYTHON_EXECUTABLE=${python3}/bin/python3"
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_ENABLE_FFI=ON"
      "-DLLVM_ENABLE_TERMINFO=OFF"
      "-DLLVM_TARGETS_TO_BUILD=X86"
    ];

    enableParallelBuilding = true;
  };

in
stdenv.mkDerivation rec {
  pname = "extempore";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "digego";
    repo = "extempore";
    rev = "v${version}";
    hash = "sha256-mtJYxLxcx7pwi82Dl1yV4tUtvkdJeC84mF+NhUZTBj8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    llvm-patched
    pcre
    libuv
    portaudio
    boost
    zlib
    mesa
    libGL
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    xorg.xorgproto
    xorg.libXcursor
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrender
  ];

  cmakeFlags = [
    "-DLLVM_DIR=${llvm-patched}"
    "-DEXT_TERM_SUPPORT=ON"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  NIX_CFLAGS_COMPILE = "-I${libGL.dev}/include";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A cyber-physical programming environment for live coding";
    homepage = "https://extemporelang.github.io/";
    license = licenses.bsd2;
    maintainers = [ maintainers.qxrein ];
    platforms = platforms.unix;
    mainProgram = "extempore";
  };
}
