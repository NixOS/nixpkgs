{
  lib,
  stdenvNoCC,
  fetchurl,
  unzrip,
}:

stdenvNoCC.mkDerivation {
  pname = "yasashisa-gothic";
  version = "0-unstable-2014-03-13";

  src = fetchurl {
    url = "http://flop.sakura.ne.jp/font/fontna-op/07Yasashisa.zip";
    hash = "sha256-JmsRvUak9FBjDw8wNA2R3lEt52/UpElleziQqa5Pm4w=";
  };

  unpackPhase = ''
    runHook preUnpack

    ${lib.getExe unzrip} -O SHIFT_JIS "$src"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 "07Yasashisa/07やさしさゴシック.ttf" -t "$out/share/fonts/truetype"
    install -Dm444 "07Yasashisa/その他-サポート外/OpenType/YasashisaGothic.otf" -t "$out/share/fonts/opentype"

    runHook postInstall
  '';

  meta = {
    description = "Free gothic style font by Fontna";
    homepage = "http://www.fontna.com/blog/379/";
    license = with lib.licenses; [
      ipa
      mplus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
