{
  stdenv,
  fetchzip,
  lib,
  autoPatchelfHook,
  libz,
}:
let
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";
  suffix =
    {
      x86_64-linux = "lin64_standalone";
      x86_64-darwin = "mac64_standalone";
    }
    .${stdenv.hostPlatform.system} or throwSystem;
  hash =
    {
      x86_64-linux = "sha256-ucG6oR4gBRUjMmHRr9QNenc04ENvwLvyCzSAqIoAiwM=";
      x86_64-darwin = "sha256-BObRSSGUra1y/oo3ZFfIGi2PdHDX2gZy315x7R9DQPk=";
    }
    .${stdenv.hostPlatform.system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "volatility2-bin";
  version = "2.6.1";

  src = fetchzip {
    url = "https://github.com/volatilityfoundation/volatility/releases/download/${finalAttrs.version}/volatility_${lib.versions.majorMinor finalAttrs.version}_${suffix}.zip";
    stripRoot = true;
    inherit hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  buildInputs = [
    libz
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    install $src/volatility_2.6_${suffix} -D -T $out/bin/volatility2
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      ${stdenv.cc.targetPrefix}install_name_tool \
        -change /usr/lib/libz.1.dylib "${libz}/lib/libz.1.dylib" \
        $out/bin/volatility2
    ''}
    ln -s $out/bin/volatility2 $out/bin/vol2
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://volatilityfoundation.org/";
    mainProgram = "volatility2";
    description = "Advanced memory forensics framework";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ ivyfanchiang ];
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    changelog = "https://github.com/volatilityfoundation/volatility/releases/tag/${finalAttrs.version}";
  };
})
