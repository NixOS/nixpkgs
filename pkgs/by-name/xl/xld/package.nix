{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  writeShellApplication,
  curl,
  xmlstarlet,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xld";
  version = "20250302";

  src = fetchurl {
    url = "mirror://sourceforge/xld/xld-${finalAttrs.version}.dmg";
    hash = "sha256-ADKlRw6k4yoRo1uAd+v0mGECiR+OuCdDCU8sZiGtius=";
  };

  buildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -r *.app "$out/Applications"
    cp -r CLI/xld "$out/bin"

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace CLI/xld \
    --replace "/Applications/XLD.app" "$out/Applications/XLD.app"
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "xld-update-script";
    runtimeInputs = [
      curl
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      url=$(curl --silent "https://svn.code.sf.net/p/xld/code/appcast/xld-appcast_e.xml")
      version=$(echo "$url" | xmlstarlet sel -t -v "//enclosure/@sparkle:shortVersionString")
      update-source-version xld "$version" --file=./pkgs/by-name/xl/xld/package.nix
    '';
  });

  meta = {
    description = "Lossless audio decoder";
    homepage = "https://tmkk.undo.jp/xld/index_e.html";
    license = lib.licenses.osl3;
    maintainers = with lib.maintainers; [ iivusly ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "xld";
  };
})
