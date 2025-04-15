{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  makeWrapper,
}:
let
  version = "4.1.4";
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";

  plat =
    {
      aarch64-darwin = "macos-arm64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-darwin = "sha256-x7piRWxtlEF3XJDKbwo9+AD4LO3k6SOJ+TRTbejPUuk=";
      aarch64-linux = "sha256-oUU371GpnBpVw3ZLc7gWgdhP91GXrXZvmmYo1hDPJ08=";
      x86_64-darwin = "sha256-zQ4adIfAuRip9LLSLTGHUhgeiRi4Z1cLQJCC9pR1zYg=";
      x86_64-linux = "sha256-D6i7uL7KckL2RVvwG7410wg4ePYwjsSkzsMK7Ra8pG0=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation {
  inherit version;
  pname = "tailwindcss_4";

  src = fetchurl {
    url =
      "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-" + plat;
    inherit hash;
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/tailwindcss
  '';

  # libstdc++.so.6 for @parcel/watcher
  postFixup = ''
    wrapProgram $out/bin/tailwindcss --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ stdenv.cc.cc.lib ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tailwindcss";
  versionCheckProgramArg = "--help";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone v4 CLI";
    homepage = "https://tailwindcss.com/blog/tailwindcss-v4";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      adamcstephens
      adamjhf
    ];
    mainProgram = "tailwindcss";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
