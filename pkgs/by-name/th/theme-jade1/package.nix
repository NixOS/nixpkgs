{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "theme-jade1";
  version = "1.15";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-jade-1/releases/download/v${finalAttrs.version}/jade-1-theme.tar.xz";
    sha256 = "sha256-VfV3dVpA3P0ChRjpxuh6C9loxr5t3s1xK0BP3DOCeQ4=";
  };

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Jade* $out/share/themes
    runHook postInstall
  '';

  meta = {
    description = "Based on Linux Mint theme with dark menus and more intensive green";
    homepage = "https://github.com/madmaxms/theme-jade-1";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
})
