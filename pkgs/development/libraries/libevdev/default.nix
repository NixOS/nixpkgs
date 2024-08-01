{ lib, stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.13.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-PsqGps5VuB1bzpEGN/xFHIu+NzsflpjzdcfxrQ3jrEg=";
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
