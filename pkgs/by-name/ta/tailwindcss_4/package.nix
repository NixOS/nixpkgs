{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  makeWrapper,
}:
let
  version = "4.1.1";
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
      aarch64-darwin = "sha256-moydWSkhoHmxd+4zeWwgneUNHOlJ9yqPXlGHhCQmYXA=";
      aarch64-linux = "sha256-zTW+fGIkpwWRYMRJjZRJmO4YI5J6gOXOKUfq9KtGxKI=";
      x86_64-darwin = "sha256-JPnnUj30uQVvj+dnq7+fG4Trt7ArLVPsP4G1RVUeZAA=";
      x86_64-linux = "sha256-jIW4NmIW7dk3iTS0JY5V7PF9LfnWIVEDcYOUP0nWp1Y=";
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
