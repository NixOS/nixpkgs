{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "6.1.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${pname}-${version}.tar.bz2";
    sha256 = "033mnhq3mx0qz3z85vw01rz5wzmx5ynadl7q1wm2spvx3ryvs6sh";
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
