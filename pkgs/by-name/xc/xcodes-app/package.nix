{
  lib,
  fetchzip,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "xcodes-app";
  version = "4.1.1b41";

  src = fetchzip {
    url = "https://github.com/XcodesOrg/XcodesApp/releases/download/v${finalAttrs.version}/Xcodes.zip";
    hash = "sha256-Ncm9aeRCMwEfJQuLHQaoo9UVhGQopbDAPK6d5ZjBDYs= ";
    stripRoot = false;
  };

  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Xcodes.app $out/Applications/Xcodes.app

    runHook postInstall
  '';

  meta = {
    description = "The easiest way to install and switch between multiple versions of Xcode";
    downloadPage = "https://github.com/XcodesOrg/XcodesApp/releases";
    homepage = "https://github.com/XcodesOrg/XcodesApp";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ paige ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
