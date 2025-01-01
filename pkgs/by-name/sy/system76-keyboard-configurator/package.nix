{
  lib,
  fetchFromGitHub,
  rustPlatform,
  gtk3,
  glib,
  wrapGAppsHook3,
  libusb1,
  hidapi,
  udev,
  pkg-config,
}:

# system76-keyboard-configurator tries to spawn a daemon as root via pkexec, so
# your system needs a PolicyKit authentication agent running for the
# configurator to work.

rustPlatform.buildRustPackage rec {
  pname = "system76-keyboard-configurator";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "keyboard-configurator";
    rev = "v${version}";
    sha256 = "sha256-rnKWzct2k/ObjBnf90uwMar7fjZAUvQ2RPPZVZQsWEA=";
  };

  nativeBuildInputs = [
    pkg-config
    glib # for glib-compile-resources
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    hidapi
    libusb1
    udev
  ];

  cargoHash = "sha256-3FUcJHuMOSbtE0sL6N2AvedyseJ7RiUbo8jtY/nWAW0=";

  postInstall = ''
    install -Dm444 linux/com.system76.keyboardconfigurator.desktop -t $out/share/applications
    cp -r data/icons $out/share
  '';

  meta = with lib; {
    description = "Keyboard configuration application for System76 keyboards and laptops";
    mainProgram = "system76-keyboard-configurator";
    homepage = "https://github.com/pop-os/keyboard-configurator";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ mirrexagon ];
    platforms = platforms.linux;
  };
}
