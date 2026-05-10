{
  lib,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  pkg-config,
  glib,
  gtk3,
  openssl,
  wayland,
  xdotool,
  makeDesktopItem,
  libayatana-appindicator,
  imagemagick,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "windsend-rs";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3D6Uj8buMceqXov6An+OxgOTcNFrX5PwxhphtbeUv0=";
  };

  cargoHash = "sha256-uRL9cnvEZzaO/Qewl8Nm1LZlidCLLDC/RDY2j5byMnE=";

  sourceRoot = "${finalAttrs.src.name}/windSend-rs";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    imagemagick
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    wayland
    xdotool
  ];

  checkFlags = [
    # need x11 server
    "--skip=route::sync_session::tests::idle_transport_sends_single_heartbeat_probe"
    "--skip=route::sync_session::tests::out_of_order_event_is_rejected_with_protocol_close"
    "--skip=route::sync_session::tests::peer_close_releases_session_instead_of_detaching"
    "--skip=route::sync_session::tests::resume_after_disconnect_replays_detached_queue"
    "--skip=route::sync_session::tests::slow_partial_inbound_frame_does_not_trip_peer_silence_timeout"
    "--skip=sync::clipboard_event_hub::tests::remote_applies_update_baseline_without_fan_out"
    "--skip=sync::clipboard_event_hub::tests::semantic_duplicates_are_not_fanned_out_twice"
    "--skip=sync::session_registry::tests::detached_session_keeps_fan_out_queue_until_ttl_expires"
    "--skip=sync::session_registry::tests::resume_attach_rejects_expired_sessions"
    "--skip=sync::session_registry::tests::resume_attach_rotates_token_bumps_generation_and_applies_resume_ack"
    "--skip=sync::session_registry::tests::start_attach_rejects_duplicate_session_ids"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "windsend-rs";
      exec = "wind_send";
      icon = "windsend-rs";
      desktopName = "WindSend";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick icon-192.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/windsend-rs.png
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libayatana-appindicator ]} $out/bin/wind_send
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quickly and securely sync clipboard, transfer files and directories between devices";
    homepage = "https://github.com/doraemonkeys/WindSend";
    mainProgram = "wind_send";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
