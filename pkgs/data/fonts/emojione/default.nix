{ stdenv, fetchFromGitHub, inkscape, imagemagick, potrace, svgo, scfbuild }:

stdenv.mkDerivation rec {
  name = "emojione-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "emojione-color-font";
    rev = "v${version}";
    sha256 = "0hgs661g1j91lkafhrfx5ix7ymarh5bzcx34r2id6jl7dc3j41l3";
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
