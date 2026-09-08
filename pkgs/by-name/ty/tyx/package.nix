{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  fetchNpmDeps,

  # nativeBuildInputs
  cargo-tauri,
  bun,
  pkg-config,
  wrapGAppsHook4,

  # buildInputs
  gtk3,
  gobject-introspection,
  webkitgtk_4_1,
}:

let
  pin = lib.importJSON ./pin.json;

  src = fetchFromGitHub {
    owner = "tyx-editor";
    repo = "TyX";
    tag = "v${pin.version}";
    hash = pin.srcHash;
  };

  node_modules = stdenv.mkDerivation {
    pname = "tyx-node_modules";
    inherit src;
    version = pin.version;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    buildPhase = ''
      bun install --no-progress --frozen-lockfile
    '';
    installPhase = ''
      mkdir -p $out/node_modules

      cp -R ./node_modules $out
    '';
    outputHash = pin."${stdenv.system}";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tyx";
  inherit (pin) version;
  inherit src;

  cargoPatches = [
    ./0001-fix-duplicate-typst-macros.patch
  ];

  fetchCargoVendor = true;
  inherit (pin) cargoHash;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -R ./* $out

    # bun is referenced naked in the package.json generated script
    makeBinaryWrapper ${lib.getExe bun} $out/bin/tyx \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install --cwd $out ./src/app.ts"

    runHook postInstall
  '';

  nativeBuildInputs = [
    cargo-tauri.hook

    bun

    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gobject-introspection
    gtk3
    webkitgtk_4_1 # javascriptcoregtk
  ];

  meta = {
    description = "A LyX-like experience rewritten for Typst and the modern era";
    homepage = "https://github.com/tyx-editor/TyX";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tyx";
  };
})
