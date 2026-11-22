{
  lib,
  fetchzip,
  unzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "xrpc";
  version = "1.0.6";

  src = fetchzip {
    url = "https://github.com/llsc12/XRPC/releases/download/v${finalAttrs.version}/XRPC.zip";
    hash = "sha256-S1MDVYP6sNRRZf5qrx+BK6OWCu13w15syfbD8duPkNE=";
  };

  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/XRPC.app
    cp -R . $out/Applications/XRPC.app/

    runHook postInstall
  '';

  meta = {
    description = "Xcode Discord Rich Presence utility";
    downloadPage = "https://github.com/llsc12/XRPC/releases/";
    homepage = "https://github.com/llsc12/XRPC";
    donationPage = "https://github.com/sponsors/llsc12";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ paige ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
