{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "stix-two-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/stixfonts/Current%20Release/STIXv${version}.zip";
    sha256 = "0f6rcg0p2dhnks523nywgkjk56bjajz3gnwsrap932674xxjkb3g";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v "Fonts/OTF/"*.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
