{
  lib,
  fetchFromGitHub,
  libxcb,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  rustPlatform,
  xcb-util-cursor,
  xwayland,
  withSystemd ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    tag = "v${version}";
    hash = "sha256-m+9tUfsmBeF2Gn4HWa6vSITZ4Gz1eA1F5Kh62B0N4oE=";
  };

  postPatch = ''
    substituteInPlace resources/xwayland-satellite.service \
      --replace-fail '/usr/local/bin' "$out/bin"
  '';

  cargoHash = "sha256-2+qQSCyWOtOJ4fTVCHbvHYO+k4vxC2nbEOJMdjQZOgY=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxcb
    xcb-util-cursor
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withSystemd "systemd";

  # All integration tests require a running display server
  doCheck = false;

  postInstall = lib.optionalString withSystemd ''
    install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
  '';

  postFixup = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xwayland outside your Wayland compositor";
    longDescription = ''
      Grants rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base.
    '';
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    changelog = "https://github.com/Supreeeme/xwayland-satellite/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      if-loop69420
      sodiboo
      getchoo
    ];
    mainProgram = "xwayland-satellite";
    platforms = lib.platforms.linux;
  };
}
