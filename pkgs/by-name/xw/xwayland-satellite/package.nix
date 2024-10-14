{
  lib,
  fetchFromGitHub,
  libxcb,
  makeWrapper,
  pkg-config,
  rustPlatform,
  unstableGitUpdater,
  xcb-util-cursor,
  xwayland,
  withSystemd ? true,
}:

rustPlatform.buildRustPackage {
  pname = "xwayland-satellite";
  version = "0.4-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "b962a0f33b503aa39c9cf6919f488b664e5b79b4";
    hash = "sha256-OANPb73V/RQDqtpIcbzeJ93KuOHKFQv+1xXC44Ut7tY=";
  };

  postPatch = ''
    substituteInPlace resources/xwayland-satellite.service \
      --replace-fail '/usr/local/bin' "$out/bin"
  '';

  cargoHash = "sha256-1EtwGMoLfYK0VZj8jdQiweO/RHGBzyEoeMEI4pmqfu8=";

  nativeBuildInputs = [
    makeWrapper
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

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Xwayland outside your Wayland compositor";
    longDescription = ''
      Grants rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base.
    '';
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
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
