{
  lib,
  stdenv,
  fetchurl,
  libdvdcss,
}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "4.9.9";

  src = fetchurl {
    url = "http://dvdnav.mplayerhq.hu/releases/libdvdread-${version}.tar.xz";
    sha256 = "d91275471ef69d488b05cf15c60e1cd65e17648bfc692b405787419f47ca424a";
  };

  buildInputs = [ libdvdcss ];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library for reading DVDs";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.linux;
  };
}
