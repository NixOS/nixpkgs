{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, xwayland
, xcb-util-cursor
, libxcb
, nix-update-script
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "v${version}";
    hash = "sha256-dwF9nI54a6Fo9XU5s4qmvMXSgCid3YQVGxch00qEMvI=";
  };

  cargoHash = "sha256-nKPSkHbh73xKWNpN/OpDmLnVmA3uygs3a+ejOhwU3yA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    libxcb
    xcb-util-cursor
  ];

  # disable Xwayland integration tests which need a running display server
  checkFlags = [
    "--exact"
    "--skip=copy_from_wayland"
    "--skip=copy_from_x11"
    "--skip=input_focus"
    "--skip=quick_delete"
    "--skip=reparent"
    "--skip=toplevel_flow"
  ];

  postInstall = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [xwayland]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base";
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = licenses.mpl20;
    maintainers = with maintainers; [ if-loop69420 sodiboo ];
    mainProgram = "xwayland-satellite";
    platforms = platforms.linux;
  };
}
