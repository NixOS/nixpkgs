{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "u001";
  version = "unstable-2016-08-01"; # date in the zip file, actual creation date unknown

  src = fetchzip {
    urls = [
      "https://fontlibrary.org/assets/downloads/u001/3ea00b3c0c8fa6ce4373e5766fafd651/u001.zip"
      "https://web.archive.org/web/20220830085803/https://fontlibrary.org/assets/downloads/u001/3ea00b3c0c8fa6ce4373e5766fafd651/u001.zip"
    ];
    hash = "sha256-7H32pfr0g68XP5B48VUY99e6fbd7rhH6fEnCKNXWEkU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    TTF_DIR=$out/share/fonts/truetype

    mkdir -p $TTF_DIR

    # We’ll adjust the nonstandard naming convention here
    cp u001-reg.ttf $TTF_DIR/U001-Regular.ttf
    cp u001-ita.ttf $TTF_DIR/U001-Italic.ttf
    cp u001-bol.ttf $TTF_DIR/U001-Bold.ttf
    cp u001-bolita.ttf $TTF_DIR/U001-BoldItalic.ttf
    cp u001con-reg.ttf $TTF_DIR/U001Condensed-Regular.ttf
    cp u001con-ita.ttf $TTF_DIR/U001Condensed-Italic.ttf
    cp u001con-bol.ttf $TTF_DIR/U001Condensed-Bold.ttf
    cp u001con-bolita.ttf $TTF_DIR/U001Condensed-BoldItalic.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Univers-like typeface that comes with GhostPDL made by URW++";
    homepage = "https://fontlibrary.org/en/font/u001";
    license = licenses.aladdin;
    platforms = platforms.all;
    maintainers = with maintainers; [ toastal ];
  };
}
