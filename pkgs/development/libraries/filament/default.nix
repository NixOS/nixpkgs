{ clang11Stdenv, fetchFromGitHub, cmake, file, ninja, python3, lib
, libXext, libXi, libglvnd, libxcb, libX11, libXxf86vm
, darwin
}:

clang11Stdenv.mkDerivation rec {
  pname = "filament";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "google";
    repo = "filament";
    rev = "v${version}";
    sha256 = "1w11avrla9j1cjm58gm7hvf7xs5f40vjfhx2c251x6siq652zw3i";
  };

  cmakeFlags = lib.optionals clang11Stdenv.isLinux [
    "-DUSE_STATIC_LIBCXX=OFF"
  ];

  preConfigure = ''
    patchShebangs --build $(find -name '*.py' -or -name '*.sh')
  '';

  nativeBuildInputs = [
    cmake
    file
    ninja
    python3
  ];

  buildInputs = [
  ] ++ lib.optionals clang11Stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
    Foundation
    ForceFeedback
    OpenGL
  ]) ++ lib.optionals clang11Stdenv.isLinux [
    libX11
    libXext
    libXi
    libXxf86vm
    libglvnd
    libxcb
  ];

  meta = with lib; {
    homepage = "https://google.github.io/filament/";
    description = "Filament is a real-time physically based rendering engine for Android, iOS, Windows, Linux, macOS, and WebGL2";
    license = licenses.asl20;
    maintainers = [ maintainers.lucus16 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
