{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  fontconfig,
  lttng-ust_2_12,
  xorg,
  icu,
  openssl,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watt-toolkit";
  version = "3.0.0-rc.16";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "x64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/BeyondDimension/SteamTools/releases/download/${finalAttrs.version}/Steam++_v${finalAttrs.version}_linux_${arch}.tgz";
      hash = selectSystem {
        x86_64-linux = "sha256-mUk/gh8GPYwhs5OZzKorkNIMMKl+amFrwbTtH0AnHTI=";
        aarch64-linux = "sha256-xfzxxxMKsoMww9PzB/nvRcxqOqyn65escvxkzK9csCo=";
      };
    };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    fontconfig
    lttng-ust_2_12
  ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack

    mkdir -p $sourceRoot
    tar -xzf $src -C $sourceRoot

    runHook postUnpack
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "watt-toolkit";
      exec = "watt-toolkit";
      icon = "watt-toolkit";
      desktopName = "Watt Toolkit";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin
    cp -r . $out/opt/watt-toolkit
    find $out/opt/watt-toolkit/modules -type f -name 'Steam++.*' -exec chmod 755 {} \;
    install -Dm644 $out/opt/watt-toolkit/Icons/Watt-Toolkit.png $out/share/pixmaps/watt-toolkit.png
    makeWrapper $out/opt/watt-toolkit/dotnet/dotnet $out/bin/watt-toolkit \
      --inherit-argv0 \
      --add-flags $out/opt/watt-toolkit/assemblies/Steam++.dll \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXrandr
          xorg.libXi
          xorg.libICE
          xorg.libSM
          xorg.libXcursor
          xorg.libXext
          icu
          openssl
          fontconfig
          lttng-ust_2_12
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Multi-purpose Steam toolkit";
    homepage = "https://github.com/BeyondDimension/SteamTools";
    mainProgram = "watt-toolkit";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
