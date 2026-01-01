{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  autoPatchelfHook,
  makeWrapper,
}:
let
<<<<<<< HEAD
  version = "4.1.18";
=======
  version = "4.1.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      aarch64-darwin = "sha256-fydxHc6sGlgLatWN2sRuWSAshabBby8I9v3N7iYQCOE=";
      aarch64-linux = "sha256-encC22yTcYqbZlXUVTBO3aGGAPWk8ZUkI0LtO1tw6+g=";
      x86_64-darwin = "sha256-Hop3/XlqOkqj2HJ4h96SbvnThHeroRP9fDLA0xoyo6s=";
      x86_64-linux = "sha256-c3vs+NStERXqmN9p+pQCbUAsqP65EwagNbWwBBZ9qN0=";
=======
      aarch64-darwin = "sha256-hSti2Rpt+laWloa8ikuuDkci3o9am0KxArtYm37OjP4=";
      aarch64-linux = "sha256-JkaJmEMRzCyhBKnWpNA5tCZ67PRUPcnqC7wJTusMzI0=";
      x86_64-darwin = "sha256-YzfIcYUyHAeSRN+9nCRQKjAGQBvRU50ZzcnfjekQGEM=";
      x86_64-linux = "sha256-zBFdm2xO3k5CO/6mo8/D8D5sFwK32RA2m5VA4rTPOGA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
