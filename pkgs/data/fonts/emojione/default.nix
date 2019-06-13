{ stdenv, fetchFromGitHub, inkscape, imagemagick, potrace, svgo, scfbuild }:

stdenv.mkDerivation rec {
  name = "emojione-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "emojione-color-font";
    rev = "v${version}";
    sha256 = "1781kxfbhnvylypbkwxc3mx6hi0gcjisfjr9cf0jdz4d1zkf09b3";
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
    homepage = http://emojione.com/;
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ abbradar ];
  };
}
