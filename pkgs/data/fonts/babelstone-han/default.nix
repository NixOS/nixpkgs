{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "babelstone-han-${version}";
  version = "9.0.2";

  src = fetchurl {
    url = "http://www.babelstone.co.uk/Fonts/8672/BabelStoneHan.zip";
    sha256 = "09zlrp3mqdsbxpq4sssd8gj5isnxfbr56pcdp7mnr27nv4pvp6ha";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 32600 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
