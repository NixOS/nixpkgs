{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "windows10-theme";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "B00merang-Project";
    repo = "Windows-10";
    rev = "${finalAttrs.version}";
    hash = "sha256-O8sKYHyr1gX1pQRTTSw/kHREJ5MujbVjmLHJHbrUcRM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/Windows10
    find . \
      ! -path ./README.md \
      -mindepth 1 -maxdepth 1 \
      -exec cp -r {} $out/share/themes/Windows10 \;

    runHook postInstall
  '';

  dontConfigure = true;
  dontBuild = true;

  meta = {
    description = "Windows 10 Light theme for Linux (GTK)";
    homepage = "https://github.com/B00merang-Project/Windows-10";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Freed-Wu ];
    platforms = lib.platforms.linux;
  };
})
