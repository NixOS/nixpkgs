{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  cmake,
  alsa-lib,
  Carbon,
  CoreAudio,
  CoreFoundation,
  CoreMIDI,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "portmidi";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uqBeh9vBP6+V+FN4lfeGxePQcpZMDYUuAo/d9a5rQxU=";
  };

  cmakeFlags = [
    "-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=Release"
  ];

  patches = [
    # Add missing header include
    ./missing-header.diff
  ];

  postInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      ln -s libportmidi${ext} "$out/lib/libporttime${ext}"
    '';

  nativeBuildInputs = [
    unzip
    cmake
  ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      CoreAudio
      CoreFoundation
      CoreMIDI
      CoreServices
    ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/PortMidi/portmidi";
    description = "Platform independent library for MIDI I/O";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
