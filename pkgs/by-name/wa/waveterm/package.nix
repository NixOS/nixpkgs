{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "waveterm";
  version = "0.7.6";

  suffix =
    {
      x86_64-linux = "linux-x86_64-${version}.AppImage";
      x86_64-darwin = "darwin-universal-${version}.dmg";
      aarch64-darwin = "darwin-universal-${version}.dmg";
    }
    .${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/Wave-${suffix}";
    hash =
      {
        x86_64-linux = "sha256-JacFG2jBhLvl+hMkHQG+VfKoDJd1cgU2S3gkloSeh5A=";
        x86_64-darwin = "sha256-b75eQnUteQ767+crVe+gWfBf7PrrEjoNFVTx8s/jTXM=";
        aarch64-darwin = "sha256-b75eQnUteQ767+crVe+gWfBf7PrrEjoNFVTx8s/jTXM=";
      }
      .${system} or throwSystem;
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  meta = with lib; {
    description = "An Open-Source, AI-Native, Terminal Built for Seamless Workflows";
    longDescription = ''
      Wave is an open-source AI-native terminal built for seamless workflows.
      Wave isn't just another terminal emulator; it's a rethink on how terminals are built.
      Wave combines command line with the power of the open web to help veteran CLI users and new developers alike.
    '';
    homepage = "https://waveterm.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ Marin-Kitagawa ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "waveterm";
  };

  linux = appimageTools.wrapType2 rec {
    inherit
      pname
      version
      src
      meta
      ;

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/Wave.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/Wave.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/Wave.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ _7zz ];

    sourceRoot = "Waveterm.app";

    # 7zz did not unpack in setup hook for some reason, done manually here
    unpackPhase = ''
      7zz x $src
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Waveterm.app
      cp -R . $out/Applications/Waveterm.app
      runHook postInstall
    '';
  };
in
if stdenv.isDarwin then darwin else linux
