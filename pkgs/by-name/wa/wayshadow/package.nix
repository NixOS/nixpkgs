{
  lib,
  stdenv,
  cairo,
  fetchFromGitHub,
  glib,
  gtk3,
  libappindicator,
  libinput,
  libxkbcommon,
  nix-update-script,
  pango,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayshadow";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "justanoobcoder";
    repo = "wayshadow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YNJWirakjJnqp119NQunRuXeQd7JYDghyi8NavtfQGI=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    glib
    gtk3
    libappindicator
    libinput
    libxkbcommon
    pango
    wayland
    wayland-protocols
  ];

  makeFlags = [
    "WAYLAND_PROTOCOLS_DIR=${wayland-protocols}/share/wayland-protocols"
    "GIT_COMMIT=nix-build"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 wayshadow        $out/bin/wayshadow
    install -D -m 644 man/wayshadow.1  $out/share/man/man1/wayshadow.1
    install -D -m 644 man/wayshadow.conf.5 $out/share/man/man5/wayshadow.conf.5

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keystroke visualizer for Wayland compositors";
    homepage = "https://github.com/justanoobcoder/wayshadow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justanoobcoder ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshadow";
  };
})
