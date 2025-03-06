{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  libglvnd,
  libxkbcommon,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ukmm";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "NiceneNerd";
    repo = "ukmm";
    tag = "v${version}";
    hash = "sha256-NZN+T2N+N+oxrjBRvVbRWbB2KY5im9SN7gPHzfvovl8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eDYCF+bYh0T/SSrQKjCqZvSd28CSxvGkpHgmBCHLoig=";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libglvnd
    libxkbcommon
    openssl
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "-Wl,--pop-state"
  ];

  cargoTestFlags = [
    "--all"
  ];

  checkFlags = [
    # Requires a game dump of Breath of the Wild
    "--skip=gui::tasks::tests::remerge"
    "--skip=pack::tests::pack_mod"
    "--skip=project::tests::project_from_mod"
    "--skip=tests::read_meta"
    "--skip=unpack::tests::read_mod"
    "--skip=unpack::tests::unpack_mod"
    "--skip=unpack::tests::unzip_mod"

    # Requires Clear Camera mod
    "--skip=bnp::test_convert"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "New mod manager for The Legend of Zelda: Breath of the Wild";
    homepage = "https://github.com/NiceneNerd/ukmm";
    changelog = "https://github.com/NiceneNerd/ukmm/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
    mainProgram = "ukmm";
  };
}
