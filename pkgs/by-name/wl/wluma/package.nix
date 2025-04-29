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

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    tag = version;
    hash = "sha256-K/AJP+2J+u83sCCbyXvCLh51Ip979nSnb0bjT22Y2+0=";
  };

  postPatch = ''
    # Needs chmod and chgrp
    substituteInPlace 90-wluma-backlight.rules --replace-fail \
      'RUN+="/bin/' 'RUN+="${coreutils}/bin/'

    substituteInPlace wluma.service --replace-fail \
      'ExecStart=/usr/bin/wluma' 'ExecStart=${placeholder "out"}/bin/wluma'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-+uJ9SytwucYiuzTwdKTAfHb81LyV9NZmGOlzm6Qjftw=";

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
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${version}";
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
}
