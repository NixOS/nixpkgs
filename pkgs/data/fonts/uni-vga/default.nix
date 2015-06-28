{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation {
  name = "uni-vga";

  src = fetchurl {
    url = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/uni-vga.tgz;
    sha256 = "05sns8h5yspa7xkl81ri7y1yxf5icgsnl497f3xnaryhx11s2rv6";
  };

  buildInputs = [ mkfontdir mkfontscale ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp *.bdf $out/share/fonts
    cd $out/share/fonts
    mkfontdir
    mkfontscale
  '';

  meta = {
    description = "Unicode VGA font";
    maintainers = [stdenv.lib.maintainers.ftrvxmtrx];
    homepage = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
