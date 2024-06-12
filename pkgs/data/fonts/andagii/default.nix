{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "andagii";
  version = "1.0.2";

  src = fetchzip {
    url = "http://www.i18nguy.com/unicode/andagii.zip";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    hash = "sha256-U7wC55G8jIvMMyPcEiJQ700A7nkWdgWK1LM0F/wgDCg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -v ANDAGII_.TTF $out/share/fonts/truetype/andagii.ttf

    runHook postInstall
  '';

  # There are multiple claims that the font is GPL, so I include the
  # package; but I cannot find the original source, so use it on your
  # own risk Debian claims it is GPL - good enough for me.
  meta = with lib; {
    homepage = "http://www.i18nguy.com/unicode/unicode-font.html";
    description = "Unicode Plane 1 Osmanya script font";
    maintainers = with maintainers; [ raskin ];
    license = "unknown";
    platforms = platforms.all;
  };
}
