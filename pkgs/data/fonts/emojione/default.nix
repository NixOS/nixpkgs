{ stdenv, fetchFromGitHub, inkscape, imagemagick, potrace, svgo, scfbuild }:

stdenv.mkDerivation rec {
  name = "emojione-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "emojione-color-font";
    rev = "v${version}";
    sha256 = "001c2bph4jcdg9arfmyxrscf1i09gvg44kqy28chjmhxzq99hpcg";
  };

  preBuild = ''
    sed -i 's,SCFBUILD :=.*,SCFBUILD := scfbuild,' Makefile
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ inkscape imagemagick potrace svgo scfbuild ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 build/EmojiOneColor-SVGinOT.ttf $out/share/fonts/truetype/EmojiOneColor-SVGinOT.ttf
  '';

  meta = with stdenv.lib; {
    description = "Open source emoji set";
    homepage = "http://emojione.com/";
    licenses = licenses.cc-by-40;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
