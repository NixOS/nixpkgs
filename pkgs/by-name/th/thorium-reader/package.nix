{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg ? null,
}:

let
  pname = "thorium-reader";
  version = "3.2.2";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.AppImage";
      sha256 = "1786sk811pbxr0mzgcyn49hld15m7asfy8a7fx1ld4xvkl236iq6";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}-arm64.AppImage";
      sha256 = "0hzmh2km7ykm34asb7dhyvmmchn7j87vjdskz90m7jr3i70ixn32";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.dmg";
      sha256 = "055rm57vx8fcq7vqzkkya7a857ri6ikkb98im1qwv2pymzkglzmb";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}-arm64.dmg";
      sha256 = "0b7nckfql9w5xyndp2z3b32jnw31dll12xz3v74lb9ngj60pbv7x";
    };
  };
  meta = {
    description = "Thorium Reader - EPUB reader";
    homepage = "https://github.com/edrlab/thorium-reader";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ YodaDaCoda ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "thorium-reader";
  };
in
if stdenv.isLinux then
  let
    appimageContents = appimageTools.extractType2 {
      inherit pname version;
      src =
        srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    };
  in
  appimageTools.wrapType2 {
    inherit pname version meta;

    src =
      srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/thorium.desktop $out/share/applications/thorium-reader.desktop
      install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/256x256/apps/thorium-reader.png
      substituteInPlace $out/share/applications/thorium-reader.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=thorium-reader' \
        --replace-fail 'Icon=thorium' 'Icon=thorium-reader'
    '';
  }
else
  stdenv.mkDerivation {
    inherit pname version meta;

    src =
      srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    dontUnpack = true;

    buildInputs = lib.optionals stdenv.isDarwin [ undmg ];

    installPhase = ''
      mkdir -p $out/bin
      if [ "$hostPlatform" = "x86_64-darwin" ] || [ "$hostPlatform" = "aarch64-darwin" ]; then
        undmg $src
        mv Thorium\ Reader.app $out/Thorium-Reader.app
      fi
    '';
  }
