{
  lib,
  stdenv,
  rustPlatform,
  cargo-bundle,
  copyDesktopItems,
  fetchFromGitea,
  ffmpeg,
  imagemagick,
  libadwaita,
  makeDesktopItem,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tyrolienne";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "git.uku3lig.net";
    owner = "uku";
    repo = "tyrolienne";
    tag = finalAttrs.version;
    hash = "sha256-jl1h7L+Ae28A7YFoIsQqxbx2XmxxjUHebD5Xba0cB5o=";
  };

  cargoHash = "sha256-J/gS8tyy+5ZG1xl4NrYCU26lD0yvsVyRUoOXntCgVSE=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo-bundle
  ];

  buildInputs = [ libadwaita ];

  # Tests are disabled because there are none, avoids having to recompile everything twice
  doCheck = false;

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    # cargo-bundle expects the binary in target/release
    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
    mv $release_target/tyrolienne target/release/tyrolienne

    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    mkdir -p $out/Applications
    mv $app_path $out/Applications/

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    for size in 16 32 48 128 256; do
      dir="$out/share/icons/hicolor/''${size}x''${size}/apps"
      mkdir -p "$dir"
      magick data/icons/tyrolienne.png -resize ''${size}x "$dir/net.uku3lig.tyrolienne.png"
    done
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "net.uku3lig.tyrolienne";
      desktopName = "Tyrolienne";
      type = "Application";
      comment = "Compresses and uploads videos to Zipline";
      exec = "tyrolienne";
      icon = "net.uku3lig.tyrolienne";
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple tool to convert, upload, and embed videos to Zipline";
    homepage = "https://git.uku3lig.net/uku/tyrolienne";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ uku3lig ];
    mainProgram = "tyrolienne";
  };
})
