{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jetbrains-mono";
  version = "2.304";

  src = fetchzip {
    url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";
    sha256 = "sha256-rv5A3F1zdcUJkmw09st1YxmEIkIoYJaMYGyZjic8jfc=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ fonts/ttf/*.ttf
    install -Dm644 -t $out/share/fonts/truetype/ fonts/variable/*.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    changelog = "https://github.com/JetBrains/JetBrainsMono/blob/v${version}/Changelog.md";
    license = licenses.ofl;
    maintainers = with maintainers; [ vinnymeller ];
    platforms = platforms.all;
  };
}
