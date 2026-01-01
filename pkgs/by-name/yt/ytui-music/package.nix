{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  mpv,
  yt-dlp,
  makeBinaryWrapper,
<<<<<<< HEAD
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "ytui-music";
  version = "2.0.0-rc1-unstable-2025-03-03";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "ytui-music";
  version = "2.0.0-rc1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sudipghimire533";
    repo = "ytui-music";
<<<<<<< HEAD
    rev = "b90293d226f6fc27835372f145e55d385112768b";
    hash = "sha256-pRD8ySpkJz8o7DURXG8DmBsbZV9MqVlMN63gAjYl4vc=";
  };

  cargoHash = "sha256-zwlg4BDHCM+KALjP929upaDpgy1mXEz5PYaVw+BhRp0=";
=======
    rev = "v${version}";
    hash = "sha256-f/23PVk4bpUCvcQ25iNI/UVXqiPBzPKWq6OohVF41p8=";
  };

  cargoHash = "sha256-I+ciLSMvV9EqlfA1+/IC1w7pWpj9HHF/DTfAbKw2CVM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  checkFlags = [
    "--skip=tests::display_config_path"
    "--skip=tests::inspect_server_list"
  ];

<<<<<<< HEAD
  patches = [
    # This patch comes from https://github.com/sudipghimire533/ytui-music/pull/57, which was unmerged.
    ./fix-implicit-autoref-errors-in-ui-mod-rs-for-rust-1-80-plus.patch
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
    sqlite
    mpv
  ];

  postInstall = ''
    wrapProgram $out/bin/ytui_music \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/ytui_music help

    runHook postInstallCheck
  '';

<<<<<<< HEAD
  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (unstableGitUpdater {
        tagFormat = "v[0-9]*";
        tagPrefix = "v";

        # * "main" branch is newer than "latest" branch
        # * "main" branch is newer than "main" tag
        # * The "main" tag doesn't seem to be associated with commits on branches like "main" or "latest".
        branch = "main";
      })
      (nix-update-script {
        # Updating `cargoHash`
        extraArgs = [ "--version=skip" ];
      })
    ];
  };

  meta = {
    description = "Youtube client in terminal for music";
    homepage = "https://github.com/sudipghimire533/ytui-music";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "ytui_music";

    # On Darwin, this package requires sandbox-relaxed to build.
    # If the sandbox is enabled, `fetch-cargo-vendor-util` causes errors.
    # This issue may be related to: https://github.com/NixOS/nixpkgs/issues/394972
    # broken = stdenv.hostPlatform.isDarwin;
=======
  meta = with lib; {
    description = "Youtube client in terminal for music";
    homepage = "https://github.com/sudipghimire533/ytui-music";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "ytui_music";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
