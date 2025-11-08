{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unicode-idna";
  version = "16.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/idna/${finalAttrs.version}/IdnaMappingTable.txt";
    hash = "sha256-bbLvTtNfOz3nTrwuAEBKlgf3bUmfV2uNQEPPFPHtF1w=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode/idna
    cp -r $src $out/share/unicode/idna/IdnaMappingTable.txt

    runHook postInstall
  '';

  meta = {
    description = "Unicode IDNA compatible processing data";
    homepage = "http://www.unicode.org/reports/tr46/";
    license = lib.licenses.unicode-dfs-2016;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
  };
})
