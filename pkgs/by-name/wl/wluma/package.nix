{
  lib,
  stdenv,
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
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-ds/qBaQNyZ/HdetI1QdJOZcjVotz4xHgoIIuWI9xOEg=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace \
      'target/release/$(BIN)' \
      'target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/$(BIN)'

    # Needs chmod and chgrp
    substituteInPlace 90-wluma-backlight.rules --replace \
      'RUN+="/bin/' 'RUN+="${coreutils}/bin/'

    substituteInPlace wluma.service --replace \
      'ExecStart=/usr/bin/wluma' 'ExecStart=${placeholder "out"}/bin/wluma'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-1zBp6eTkIDSMzNN5jKKu6lZVzzBJY+oB6y5UESlm/yA=";

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

  postBuild = ''
    make docs
  '';

  dontCargoInstall = true;
  installFlags = [ "PREFIX=${placeholder "out"}" ];
  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [
      yshym
      jmc-figueira
      atemu
      Rishik-Y
    ];
    platforms = platforms.linux;
    mainProgram = "wluma";
  };
}
