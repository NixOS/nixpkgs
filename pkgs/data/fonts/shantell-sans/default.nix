{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shantell-sans";
  version = "1.011";

  src = fetchzip {
    url = "https://github.com/arrowtype/shantell-sans/releases/download/${finalAttrs.version}/Shantell_Sans_${finalAttrs.version}.zip";
    hash = "sha256-xgE4BSl2A7yeVP5hWWUViBDoU8pZ8KkJJrsSfGRIjOk=";
  };

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/fonts/opentype/ $(find $src -type f -name '*.otf')

    install -D -t $out/share/fonts/truetype/ "$(find $src -type f -name '*.ttf')"
    mv $out/share/fonts/truetype/"ShantellSans[BNCE,INFM,SPAC,ital,wght].ttf" $out/share/fonts/truetype/Shantell_Sans_Variable.ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://shantellsans.com/";
    description = "Marker-style font built for creative expression, typographic play, and animation";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ bodby ];
    platforms = lib.platforms.all;
  };
}
