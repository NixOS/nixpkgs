{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "6.1.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${pname}-${version}.tar.bz2";
    sha256 = "15hpwbw3nm84y432l0j61w0zmqxplsyymfc52dry6nvwl44p6d9y";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "A library for reading DVDs";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
