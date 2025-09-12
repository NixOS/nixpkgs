{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  inkscape,
  imagemagick,
  potrace,
  svgo,
  scfbuild,
}:

stdenv.mkDerivation rec {
  pname = "emojione";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "emojione-color-font";
    rev = "v${version}";
    sha256 = "1781kxfbhnvylypbkwxc3mx6hi0gcjisfjr9cf0jdz4d1zkf09b3";
  };

  patches = [
    # Fix build with Inkscape 1.0
    # https://github.com/eosrei/twemoji-color-font/pull/82
    (fetchpatch {
      url = "https://github.com/eosrei/twemoji-color-font/commit/208ad63c2ceb38c528b5237abeb2b85ceedc1d37.patch";
      sha256 = "7tDWIkpcdir1V6skgXSM3r0FwHy0F6PyJ07OPRsSStA=";
      postFetch = ''
        substituteInPlace $out \
          --replace "inkscape --without-gui" "inkscape --export-png" \
          --replace TWEMOJI EMOJIONE \
          --replace "the assets" "the emojione assets" \
          --replace twemoji emojione
      '';
    })
  ];

  preBuild = ''
    sed -i 's,SCFBUILD :=.*,SCFBUILD := scfbuild,' Makefile
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [
    inkscape
    imagemagick
    potrace
    svgo
    scfbuild
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 build/EmojiOneColor-SVGinOT.ttf $out/share/fonts/truetype/EmojiOneColor-SVGinOT.ttf
  '';

  meta = with lib; {
    description = "Open source emoji set";
    homepage = "http://emojione.com/";
    license = licenses.cc-by-40;
    maintainers = [ ];
  };
}
