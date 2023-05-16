{ lib, stdenv, fetchFromGitHub, unzip, cmake, alsa-lib, Carbon, CoreAudio, CoreFoundation, CoreMIDI, CoreServices }:

stdenv.mkDerivation rec {
  pname = "portmidi";
<<<<<<< HEAD
  version = "2.0.4";
=======
  version = "2.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-uqBeh9vBP6+V+FN4lfeGxePQcpZMDYUuAo/d9a5rQxU=";
=======
    sha256 = "sha256-bLGqi3b9FHBA43baNDT8jkPBQSXAUDfurQSJHLcy3AE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  postInstall = let ext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
    ln -s libportmidi${ext} "$out/lib/libporttime${ext}"
  '';

  nativeBuildInputs = [ unzip cmake ];
  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon CoreAudio CoreFoundation CoreMIDI CoreServices
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
