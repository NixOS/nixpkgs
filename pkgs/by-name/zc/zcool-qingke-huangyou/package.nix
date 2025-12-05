{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zcool-qingke-huangyou";
  version = "1.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "zcool-qingke-huangyou";
    rev = "c9dac424b0a9f47d3b113cff4a4922f632d82c94";
    hash = "sha256-xIIDP8gCtwNtY6AReeuLZSbnDXczS5ycObP3EKxk+hU=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = {
    description = "Futuristic stiff geometric font";
    homepage = "https://fonts.google.com/specimen/ZCOOL+QingKe+HuangYou";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gigahawk ];
  };
})
