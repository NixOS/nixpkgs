{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  name = "gohufont-2.0";

  src = fetchurl {
    url = "http://font.gohu.org/gohufont-2.0.tar.gz";
    sha256 = "0vi87fvj3m52piz2k6vqday03cah6zvz3dzrvjch3qjna1i1nb7s";
  };

  buildInputs = [ mkfontdir mkfontscale ];

  installPhase = ''
    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"
    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  meta = with stdenv.lib; {
    description = "A monospace bitmap font well suited for programming and terminal use";
    homepage = http://font.gohu.org/;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ epitrochoid ];
    platforms = with platforms; linux;
  };
}
