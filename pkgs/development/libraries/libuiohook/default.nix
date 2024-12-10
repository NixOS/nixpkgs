{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  cmake,
  pkg-config,
  AppKit,
  ApplicationServices,
  Carbon,
  libX11,
  libxkbcommon,
  xinput,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "libuiohook";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "kwhat";
    repo = pname;
    rev = version;
    sha256 = "1qlz55fp4i9dd8sdwmy1m8i4i1jy1s09cpmlxzrgf7v34w72ncm7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    if stdenv.isDarwin then
      [
        AppKit
        ApplicationServices
        Carbon
      ]
    else
      [
        libX11
        libxkbcommon
        xinput
      ]
      ++ (with xorg; [
        libXau
        libXdmcp
        libXi
        libXinerama
        libXt
        libXtst
        libXext
        libxkbfile
      ]);

  outputs = [
    "out"
    "test"
  ];

  # We build the tests, but they're only installed when using the "test" output.
  # This will produce a "uiohook_tests" binary which can be run to test the
  # functionality of the library on the current system.
  # Running the test binary requires a running X11 session.
  cmakeFlags = [
    "-DENABLE_TEST:BOOL=ON"
  ];

  postInstall = ''
    mkdir -p $test/share
    cp ./uiohook_tests $test/share
  '';

  meta = with lib; {
    description = "A C library to provide global keyboard and mouse hooks from userland";
    homepage = "https://github.com/kwhat/libuiohook";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ anoa ];
  };

  passthru.tests.libuiohook = nixosTests.libuiohook;
}
