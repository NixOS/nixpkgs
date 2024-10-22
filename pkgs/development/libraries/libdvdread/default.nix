{lib, stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "6.1.3";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zjVFSZeiCMvlDpEjLw5z+xrDRxllgToTuHMKjxihU2k=";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library for reading DVDs";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
