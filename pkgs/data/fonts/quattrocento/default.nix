{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "quattrocento-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://www.impallari.com/media/releases/quattrocento-v${version}.zip";
    sha256 = "09wmbfwkry1r2cf5z4yy67wd4yzlnsjigg01r5r80z1phl0axn9n";
  };

  buildInputs = [unzip];
  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "src/"*.otf $out/share/fonts/opentype
    cp -v FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.impallari.com/quattrocento/;
    description = "A classic, elegant, sober and strong serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
