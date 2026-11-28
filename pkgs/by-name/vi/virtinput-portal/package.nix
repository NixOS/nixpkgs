{
  lib,
  rustPlatform,
  libei,
  libxkbcommon,
  pkg-config,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "virtinput-portal";
  version = "unstable-2026-10-14";
  src = fetchFromGitHub {
    owner = "NailFec";
    repo = "virtinput-portal";
    rev = "e672a3f1e3f2c94852fe7fe6f7b2d77a718f9306";
    hash = "sha256-LsxIxH5x81Lhwjv03uftFAf8P9e73oUqtjAry7iD7S0=";
  };
  cargoHash = "sha256-hTGB/cs1cH5EgGdkqIip4H87iFZ16wlAClrmMzYWcFg=";

  buildInputs = [
    libei
    libxkbcommon
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  postPatch = ''
    substituteInPlace data/org.freedesktop.impl.portal.desktop.virtinput.service \
      --subst-var-by BIN $out/bin/virtinput-portal
    substituteInPlace data/virtinput-portal.service \
      --replace-fail "%h/.local" $out
  '';
  postInstall = ''
    mkdir -p $out/share/xdg-desktop-portal/portals
    mkdir -p $out/lib/systemd/user
    mkdir -p $out/share/dbus-1/services
    install -m 644 data/virtinput.portal -t $out/share/xdg-desktop-portal/portals
    install -m 644 data/virtinput-portal.service -t $out/lib/systemd/user
    install -m 644 data/org.freedesktop.impl.portal.desktop.virtinput.service -t $out/share/dbus-1/services
    install -m 644 data/niri-portals.conf -t $out/share/xdg-desktop-portal
  '';

  meta = {
    description = "A user-level xdg-desktop-portal backend for RemoteDesktop which injects pointer and keyboard events through the Wayland protocols, enabling you to use KDE Connect on WMs like niri.";
    homepage = "https://github.com/NailFec/virtinput-portal/tree/main";
    mainProgram = "virtinput-portal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.libewa ];
  };

  strictDeps = true;
  __structuredAttrs = true;
})
