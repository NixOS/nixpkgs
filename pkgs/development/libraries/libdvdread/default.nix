{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation {
  name = "libdvdread-4.9.9";
  
  src = fetchurl {
    url = http://dvdnav.mplayerhq.hu/releases/libdvdread-4.9.9.tar.xz;
    sha256 = "d91275471ef69d488b05cf15c60e1cd65e17648bfc692b405787419f47ca424a";
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
