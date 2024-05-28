{ lib, stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.13.1";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Bqd78qxcmTMFiCvBZBAX9b7BWS1tG2R4e61JKrNPLzY=";
  };

  nativeBuildInputs = [ python3 ];

  meta = with lib; {
    description = "Wrapper library for evdev devices";
    homepage = "https://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
