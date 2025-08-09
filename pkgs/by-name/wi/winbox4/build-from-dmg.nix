{
  pname,
  version,
  hash,
  fetchurl,
  stdenvNoCC,
  undmg,
  metaCommon ? { },
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    name = "WinBox-${finalAttrs.version}.dmg";
    url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox.dmg";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,Applications}
    cp -R "WinBox.app" "$out/Applications/WinBox.app"
    ln -s "$out/Applications/WinBox.app/Contents/MacOS/WinBox" "$out/bin/WinBox"

    runHook postInstall
  '';

  meta = metaCommon // {
    platforms = [ "aarch64-darwin" ];
  };
})
