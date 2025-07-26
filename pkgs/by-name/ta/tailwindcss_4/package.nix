{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  jq,
  libsoup_3,
  moreutils,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tailwindcss";
  version = "4.1.11";

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QjgztsXB9tz95xcthQyFFoGmbrNaG0s9JcKd8CLD0Bk=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetcherVersion = 1;
    hash = "sha256-6e1aDYGVKCIK/pBrT/sWNkErnVFDUX1GKg0govOldAI=";
  };

  #cargoRoot = "src-tauri";
  #buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      #cargoRoot
      ;
    hash = "sha256-MnNcndDbdqJNEISYCXy6TsN4+uk6/ahImAXX6XdBMWs=";
  };

  nativeBuildInputs = [
    #cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  #passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
  #  ${lib.getExe finalAttrs.finalPackage} --help > $out
  #'';
  passthru.updateScript = nix-update-script { };

  installPhase = ''
    pnpm install
  '';

  meta = {
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone CLI";
    homepage = "https://tailwindcss.com/blog/standalone-cli";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.adamcstephens ];
    mainProgram = "tailwindcss";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
