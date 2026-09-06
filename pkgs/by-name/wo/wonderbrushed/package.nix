{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wonderbrushed";
  version = "0.45-beta.1";

  src = fetchFromGitHub {
    owner = "Bhavneeth-Games";
    repo = "Wonderbrushed";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jyXeGFvNxov7NAY9jQp+gnhxBGFUI2dHX0tizlSTCAU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Wonderbrushed
    cp -r * $out/share/icons/Wonderbrushed/

    runHook postInstall
  '';

  meta = {
    description = "KDE icon pack featuring colorful, chalky icons";
    homepage = "https://github.com/Bhavneeth-Games/Wonderbrushed";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ZariTen ];
  };
})
