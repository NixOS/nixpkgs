{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "andagii-${version}";
  version = "1.0.2";

  src = fetchzip {
    url = http://www.i18nguy.com/unicode/andagii.zip;
    sha256 = "0a0c43y1fd5ksj50axhng7p00kgga0i15p136g68p35wj7kh5g2k";
    stripRoot = false;
    curlOpts = "--user-agent 'Mozilla/5.0'";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v ANDAGII_.TTF $out/share/fonts/truetype/andagii.ttf
  '';

  # There are multiple claims that the font is GPL, so I include the
  # package; but I cannot find the original source, so use it on your
  # own risk Debian claims it is GPL - good enough for me.
  meta = with stdenv.lib; {
    homepage = http://www.i18nguy.com/unicode/unicode-font.HTML;
    description = "Unicode Plane 1 Osmanya script font";
    maintainers = with maintainers; [ raskin rycee ];
    license = "unknown";
    platforms = platforms.all;
  };
}
