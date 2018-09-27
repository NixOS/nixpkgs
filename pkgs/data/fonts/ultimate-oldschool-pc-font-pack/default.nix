{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "ultimate-oldschool-pc-font-pack-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://int10h.org/oldschool-pc-fonts/download/ultimate_oldschool_pc_font_pack_v${version}.zip";
    sha256 = "7666cf23176e34ea03a218b5c1500f4ad729d97150ab7bdb7cf2adf4c99a9a7a";
  };

  buildInputs = [ unzip ];

  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp 'Px437 (TrueType - DOS charset)'/*.ttf $out/share/fonts/truetype
    cp 'PxPlus (TrueType - extended charset)'/*.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "The Ultimate Oldschool PC Font Pack (TTF Fonts)";
    homepage = "http://int10h.org/oldschool-pc-fonts/";
    platforms = platforms.unix;
    license = licenses.cc-by-sa-40;
    maintainers = [ maintainers.endgame ];
  };
}
