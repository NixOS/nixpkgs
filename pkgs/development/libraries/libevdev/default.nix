{ lib, stdenv, fetchurl, fetchpatch, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
<<<<<<< HEAD
  version = "1.13.1";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Bqd78qxcmTMFiCvBZBAX9b7BWS1tG2R4e61JKrNPLzY=";
=======
  version = "1.13.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-nt8gBsyGpQVSeWR8OOySPRGoIe5NwsMDPo0g6O4jfNk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ python3 ];

  meta = with lib; {
    description = "Wrapper library for evdev devices";
    homepage = "http://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
