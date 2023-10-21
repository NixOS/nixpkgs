{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "junicode";
  version = "2.100";

  src = fetchzip {
    url = "https://github.com/psb1558/Junicode-font/releases/download/v${version}/Junicode_${version}.zip";
    hash = "sha256-Sd3WhG846m2CXz+NKDAod5bfF91MOR1Vq0wpuOE+cDQ=";
  };

  outputs = [ "out" "doc" ];

  installPhase = ''
    runHook preInstall

    install -Dm 444 -t $out/share/fonts/truetype TTF/*.ttf VAR/*.ttf
    install -Dm 444 -t $out/share/fonts/opentype OTF/*.otf
    install -Dm 444 -t $out/share/fonts/woff2 WOFF2/*.woff2

    install -Dm 444 -t $doc/share/doc/${pname}-${version} docs/*.pdf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
