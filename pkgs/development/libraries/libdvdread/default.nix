{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  name = "libdvdread-${version}";
  version = "5.0.2";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${name}.tar.bz2";
    sha256 = "82cbe693f2a3971671e7428790b5498392db32185b8dc8622f7b9cd307d3cfbf";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library for reading DVDs";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
  };
}
