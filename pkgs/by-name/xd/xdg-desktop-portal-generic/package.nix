{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pipewire,
  wayland,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-generic";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lamco-admin";
    repo = "xdg-desktop-portal-generic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Owx4GnsVzu16Md0ARQLwkjFN5bCurhS216nguA95EDg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace data/org.freedesktop.impl.portal.desktop.generic.service \
      --replace-fail '/usr/libexec/' '${placeholder "out"}/libexec/'

    substituteInPlace data/xdg-desktop-portal-generic.service \
      --replace-fail '/usr/libexec/' '${placeholder "out"}/libexec/'
  '';

  cargoHash = "sha256-m/OdKQNX4ufUBIBg5+dZyr46X9ovgKXMLa5AvdbOQ5Q=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
    wayland
    libxkbcommon
  ];

  postInstall = ''
    install -Dm644 data/generic.portal -t $out/share/xdg-desktop-portal/portals
    install -Dm644 data/org.freedesktop.impl.portal.desktop.generic.service -t $out/share/dbus-1/services
    install -Dm644 data/xdg-desktop-portal-generic.service -t $out/share/systemd/user

    mkdir -p $out/libexec
    mv $out/bin/xdg-desktop-portal-generic $out/libexec/
    rmdir $out/bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generic XDG Desktop Portal backend for Wayland compositors";
    homepage = "https://github.com/lamco-admin/xdg-desktop-portal-generic";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrtitor ];
    platforms = lib.platforms.linux;
  };
})
