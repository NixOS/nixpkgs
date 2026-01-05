{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "tai-ahom";
  version = "unstable-2015-07-06";

  src = fetchurl {
    url = "https://github.com/enabling-languages/tai-languages/raw/b57a3ea4589af69bb8e87c6c4bb7cd367b52f0b7/ahom/.fonts/ttf/.original/AhomUnicode_FromMartin.ttf";
    hash = "sha256-U1vcVf/VgXhvK1f2Iw2JKkd2EzJgz7KbHAwnUanX8n4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/AhomUnicode.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/enabling-languages/tai-languages";
    description = "Unicode-compliant Tai Ahom font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
}
