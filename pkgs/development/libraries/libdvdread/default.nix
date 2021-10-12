{lib, stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "6.1.2";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zBkPVTdYztdXGFnjAfgCy0gh8WTQK/rP0yDBSk4Np2M=";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "A library for reading DVDs";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
