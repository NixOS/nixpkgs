{ stdenv, fetchFromGitHub, inkscape, imagemagick, potrace, svgo, scfbuild }:

stdenv.mkDerivation rec {
  name = "twemoji-color-font-${meta.version}";
  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "twemoji-color-font";
    rev = "v${meta.version}";
    sha256 = "07yawvbdkk15d7ac9dj7drs1rqln9sba1fd6jx885ms7ww2sfm7r";
  };

  nativeBuildInputs = [ inkscape imagemagick potrace svgo scfbuild ];
  # silence inkscape errors about non-writable home
  preBuild = "export HOME=\"$NIX_BUILD_ROOT\"";
  makeFlags = [ "SCFBUILD=${scfbuild}/bin/scfbuild" ];
  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 build/TwitterColorEmoji-SVGinOT.ttf $out/share/fonts/truetype/TwitterColorEmoji-SVGinOT.ttf
    install -Dm644 linux/fontconfig/56-twemoji-color.conf $out/etc/fonts/conf.d/56-twemoji-color.conf
  '';

  meta = with stdenv.lib; {
    version = "11.2.0";
    description = "Color emoji SVGinOT font using Twitter Unicode 10 emoji with diversity and country flags";
    longDescription = ''
      A color and B&W emoji SVGinOT font built from the Twitter Emoji for
      Everyone artwork with support for ZWJ, skin tone diversity and country
      flags.

      The font works in all operating systems, but will currently only show
      color emoji in Firefox, Thunderbird, Photoshop CC 2017, and Windows Edge
      V38.14393+. This is not a limitation of the font, but of the operating
      systems and applications. Regular B&W outline emoji are included for
      backwards/fallback compatibility.
    '';
    homepage = "https://github.com/eosrei/twemoji-color-font";
    downloadPage = "https://github.com/eosrei/twemoji-color-font/releases";
    license = with licenses; [ cc-by-40 mit ];
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
}
