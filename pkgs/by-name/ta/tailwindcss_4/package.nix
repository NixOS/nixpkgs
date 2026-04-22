{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  makeWrapper,
}:
let
  version = "4.2.3";
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
      aarch64-darwin = "sha256-NPuPa7rYe8BOE9BSN0Tl4fLc/ezvO/RO9+d575QjXJU=";
      aarch64-linux = "sha256-p+eWD9a64t6k+W7nTL1Qmd+W0E1kIpAqexRSnaN780U=";
      x86_64-darwin = "sha256-q3CAQUIFQczepFKTFFyXFsuFYTdjlvFI0PsECOjtTZE=";
      x86_64-linux = "sha256-rdyFwhwruoyVCCs7k2+f6jZZKYhwf4bhtN9aq5td9Ck=";
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
