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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lamco-admin";
    repo = "xdg-desktop-portal-generic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y7fdAbge1wG8lE0BUBSNGEbz3it2cZ8o80ayUEdFt8M=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace data/org.freedesktop.impl.portal.desktop.generic.service \
      --replace-fail '/usr/libexec/' '${placeholder "out"}/libexec/'

    substituteInPlace data/xdg-desktop-portal-generic.service \
      --replace-fail '/usr/libexec/' '${placeholder "out"}/libexec/'
  '';

  cargoHash = "sha256-3t2w37jqU9iLRZWldnuNZkqE4jreMe+OVl7f3ZHyGXc=";

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
