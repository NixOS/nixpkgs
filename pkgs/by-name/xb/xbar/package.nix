{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xbar";
  version = "2.1.7-beta";

  src = fetchurl {
    url = "https://github.com/matryer/xbar/releases/download/v${finalAttrs.version}/xbar.v${finalAttrs.version}.dmg";
    sha256 = "sha256-Cn6nxA5NTi7M4NrjycN3PUWd31r4Z0T3DES5+ZAbxz8=";
  };

  sourceRoot = "xbar.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/xbar.app
    cp -R . $out/Applications/xbar.app

    runHook postInstall
  '';

  meta = {
    description = "Put the output from any script or program into your macOS Menu Bar (the BitBar reboot)";
    homepage = "https://xbarapp.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mit;
  };
})
