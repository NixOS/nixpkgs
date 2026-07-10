{
  lib,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  marked-man,
  coreutils,
  vulkan-loader,
  wayland,
  pkg-config,
  udev,
  v4l-utils,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wluma";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    tag = finalAttrs.version;
    hash = "sha256-va+y/dwJ4vTyuqn4VwVXQo8F2qWJPq6F6e9/7V4qDQQ=";
  };

  postPatch = ''
    # Needs chmod and chgrp
    substituteInPlace 90-wluma-backlight.rules --replace-fail \
      'RUN+="/bin/' 'RUN+="${coreutils}/bin/'

    substituteInPlace wluma.service --replace-fail \
      'ExecStart=/usr/bin/wluma' 'ExecStart=${placeholder "out"}/bin/wluma'
  '';

  cargoHash = "sha256-qL+OnnPlQoGj7gvpYegjwN42skKUsbg+FV3cnTBwNpo=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
    marked-man
  ];

  buildInputs = [
    udev
    v4l-utils
    vulkan-loader
    dbus
  ];

  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      yshym
      jmc-figueira
      atemu
      Rishik-Y
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wluma";
  };
})
