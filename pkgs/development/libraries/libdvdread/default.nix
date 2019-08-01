{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  name = "libdvdread-${version}";
  version = "6.0.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${name}.tar.bz2";
    sha256 = "1gfmh8ii3s2fw1c8vn57piwxc0smd3va4h7xgp9s8g48cc04zki8";
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
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
