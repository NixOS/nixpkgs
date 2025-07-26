{
  fetchFromGitLab,
  lib,
  libxkbcommon,
  makeWrapper,
  meson,
  ninja,
  nix-update-script,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_19,
  xwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayback";
  version = "0.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayback";
    repo = "wayback";
    tag = "${finalAttrs.version}";
    hash = "sha256-8pfW1tu7OI6dLSR9iiVuJDdK76fRgpQmesW5wJUVN/0=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
    xwayland
  ];

  postInstall = ''
    wrapProgram "$out/bin/wayback-session" \
      --set XWAYBACK_PATH "$out/bin/Xwayback"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "X11 compatibility layer leveraging wlroots and Xwayland";
    homepage = "https://wayback.freedesktop.org";
    changelog = "https://gitlab.freedesktop.org/wayback/wayback/-/releases/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "Xwayback";
    maintainers = with lib.maintainers; [ dramforever ];
  };
})
