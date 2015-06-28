{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "quattrocento-sans-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://www.impallari.com/media/releases/quattrocento-sans-v${version}.zip";
    sha256 = "043jfdn18dgzpx3qb3s0hc541n6xv4gacsm4srd6f0pri45g4wh1";
  };

  buildInputs = [unzip];
  phases = ["unpackPhase" "installPhase"];

  sourceRoot = "quattrocento-sans-v${version}";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "src/"*.otf $out/share/fonts/opentype
    cp -v FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.impallari.com/quattrocentosans/;
    description = "A classic, elegant and sober sans-serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
