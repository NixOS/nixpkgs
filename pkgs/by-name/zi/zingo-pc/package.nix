{
  lib,
  stdenv,
  rustPlatform,
  nodejs,
  electron_40,
  gitMinimal,
  asar,
  jq,
  makeDesktopItem,
  copyDesktopItems,
  fetchurl,
  fetchFromGitHub,
  fetchYarnDeps,
  runCommand,
  makeBinaryWrapper,
  nix-update-script,
  yarnBuildHook,
  yarnConfigHook,
}:

# these "parameter" files are used in the zingolib build process. For the zcash official client and
# some other clients, these files are downloaded at runtime, but zingolib embeds them at build time.
# The way it does this is by running the typical `download_sapling_parameters` function from the
# zcash_proofs crate, which downloads into $HOME/.zcash-params on Linux or
# $XDG_DATA_HOME/ZcashParams on macOS (yes, even though macOS does not use XDG stuff, zcash_proofs
# uses the xdg crate to determine this path. I think it falls back to $HOME/.local/share when
# XDG_DATA_HOME is unset, which will be typical on macOS). Then, the zingolib build script copies
# the files from `download_sapling_parameters` into the final built crate (lovely, a crate build
# leaving behind tens of megabytes of files in a random directory under $HOME!).

# To handle this, we just create a synthetic "home dir" containing the parameter files. This will
# cause `download_sapling_parameters` to automatically skip the download.

# When bumping the version, the tag is derived automatically as `zingo-pc-${version}`.
# Also check whether the zingo repo has bumped its electron dependency and update electron_40 if so.
let
  version = "2.0.18-159";
  tag = "zingo-pc-${version}";
  saplingSpendParams = fetchurl {
    url = "https://download.z.cash/downloads/sapling-spend.params";
    hash = "sha256-jkj/0jq7Ol/ZxViSBPMtnDEoWgS3gJa6QKebdWd+/BM=";
  };
  saplingOutputParams = fetchurl {
    url = "https://download.z.cash/downloads/sapling-output.params";
    hash = "sha256-Lw67y7m7C8/+laOX5+uonCnrTd5hkcM524hXDj8/sOQ=";
  };
  zcashParamsHome = runCommand "zcash-params-home" { } ''
    mkdir -p $out/.zcash-params $out/ZcashParams
    ln -s ${saplingSpendParams} $out/.zcash-params/sapling-spend.params
    ln -s ${saplingOutputParams} $out/.zcash-params/sapling-output.params
    ln -s ${saplingSpendParams} $out/ZcashParams/sapling-spend.params
    ln -s ${saplingOutputParams} $out/ZcashParams/sapling-output.params
  '';
  src = fetchFromGitHub {
    owner = "zingolabs";
    repo = "zingo-pc";
    inherit tag;
    hash = "sha256-R1lnbyoRwZoNbLI0ZM7PQN7Z5cpRX6rDpwDC3nTN6iE=";
  };
  zingo-native = rustPlatform.buildRustPackage {
    pname = "zingolib-native";
    inherit version;

    src = src + "/native";
    cargoHash = "sha256-KQMTymNexaAkYWpBBCR9rlLCk6N3giIx1cAh29HSU/4=";

    env.HOME = zcashParamsHome;
    env.XDG_DATA_HOME = zcashParamsHome;

    # zingolib calls git to get some description
    nativeBuildInputs = [
      gitMinimal
    ];

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libzingolib_native${stdenv.hostPlatform.extensions.sharedLibrary} $out/native.node

      runHook postInstall
    '';
  };
  electron = electron_40;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zingo-pc";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Gj3yF4qteKwJkD3QZv8HPB5IBFWgfbXVkB0xjJvov0Q=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    cp ${zingo-native}/native.node src/native.node
  '';

  yarnBuildScript = "script:build";

  installPhase = ''
    runHook preInstall

    yarn install \
      --frozen-lockfile \
      --production \
      --ignore-engines \
      --ignore-platform \
      --ignore-scripts \
      --no-progress \
      --non-interactive \
      --offline

    staging=$(mktemp -d)
    # in the dist target where they use electron-builder, they override entry point to build/. This is how we do it :|
    jq '.main = "build/electron.js"' package.json > $staging/package.json
    cp -r build "$staging/"
    cp -r node_modules "$staging/"

    mkdir -p $out/lib
    # unpack native.node, needs to be dynamically loaded
    asar pack "$staging" "$out/lib/zingo-pc.asar" --unpack '**/*.node'

    install -Dm644 resources/icons/512x512.png $out/share/icons/hicolor/512x512/apps/zingo-pc.png

    makeWrapper ${lib.getExe electron} $out/bin/zingo-pc \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $out/lib/zingo-pc.asar \
      --inherit-argv0

    runHook postInstall
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    copyDesktopItems
    makeBinaryWrapper

    nodejs
    asar
    jq
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "zingo-pc-(.*)"
    ];
  };

  desktopItems = [
    (makeDesktopItem {
      name = "zingo-pc";
      desktopName = "Zingo PC";
      exec = "zingo-pc %U";
      icon = "zingo-pc";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "Finance"
      ]; # same categories as Electrum
      mimeTypes = [ "x-scheme-handler/zcash" ];
      keywords = [
        "zingo"
        "zcash"
        "wallet"
      ];
    })
  ];

  meta = {
    description = "Shielded Zcash light-client wallet";
    longDescription = ''
      Zingo PC is a shielded Zcash light-client wallet for desktop (Windows, macOS, Linux), built with Electron and powered by the Zingolib Rust SDK.
    '';
    homepage = "https://github.com/zingolabs/zingo-pc";
    changelog = "https://github.com/zingolabs/zingo-pc/releases/tag/${tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ markasoftware ];
    mainProgram = "zingo-pc";
    # probably almost works on macOS (eg, we use the correct HOME and XDG_DATA_HOME structure to put
    # zcash parameters in macOS compatible places) but idk about the electron packaging portion.
    platforms = lib.platforms.linux;
  };
})
