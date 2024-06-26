{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "d2codingfont";
  version = "1.3.2";

  src = fetchzip {
    url = "https://github.com/naver/${pname}/releases/download/VER${version}/D2Coding-Ver${version}-20180524.zip";
    stripRoot = false;
    hash = "sha256-iC6iaUSVg4zt3wVFJUU4HEeswuKDOTFsAxq/0gRiOCA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*-all.ttc -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospace font with support for Korean and latin characters";
    longDescription = ''
      D2Coding is a monospace font developed by a Korean IT Company called Naver.
      Font is good for displaying both Korean characters and latin characters,
      as sometimes these two languages could share some similar strokes.
      Since version 1.3, D2Coding font is officially supported by the font
      creator, with symbols for Powerline.
    '';
    homepage = "https://github.com/naver/d2codingfont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
