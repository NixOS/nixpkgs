{ lib, stdenv, fetchurl, fetchpatch, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.13.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-nt8gBsyGpQVSeWR8OOySPRGoIe5NwsMDPo0g6O4jfNk=";
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
