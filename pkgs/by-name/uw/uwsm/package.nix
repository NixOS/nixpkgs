{
  stdenv,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  meson,
  ninja,
  scdoc,
  pkg-config,
  fetchpatch,
  nix-update-script,
  bash,
  dmenu,
  libnotify,
  newt,
  python3Packages,
  systemd,
  util-linux,
  fumonSupport ? true,
  uuctlSupport ? true,
  uwsmAppSupport ? true,
}:
let
  python = python3Packages.python.withPackages (ps: [
    ps.pydbus
    ps.dbus-python
    ps.pyxdg
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uwsm";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UP9Ztps5oWl0bdXhSlE4SCxHFprUf74DWygJy6GvO4k=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Vladimir-csp/uwsm/commit/bd4db0fd1880b9b798e8f67e2d4c5e4ca2a28aca.patch?full_index=1";
      hash = "sha256-GxGwy9BkpBKZGkG00+bVIh6iDNBgRG1f1f9GUKm3ERw=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    util-linux # waitpid
    newt # whiptail
    libnotify # notify-send
    bash # sh
    systemd
    python
  ]
  ++ lib.optionals uuctlSupport [ dmenu ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
  ]
  ++ (lib.mapAttrsToList lib.mesonEnable {
    "uwsm-app" = uwsmAppSupport;
    "fumon" = fumonSupport;
    "uuctl" = uuctlSupport;
    "man-pages" = true;
    "canonicalize-bins" = true;
  })
  ++ (lib.mapAttrsToList lib.mesonOption {
    "python-bin" = python.interpreter;
  });

  postInstall =
    let
      wrapperArgs = "--suffix PATH : ${lib.makeBinPath finalAttrs.buildInputs}";
    in
    lib.optionalString uuctlSupport ''
      wrapProgram $out/bin/uuctl ${wrapperArgs}
    ''
    + lib.optionalString uwsmAppSupport ''
      wrapProgram $out/bin/uwsm-app ${wrapperArgs}
    ''
    + lib.optionalString fumonSupport ''
      wrapProgram $out/bin/fumon ${wrapperArgs}
    '';

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Universal wayland session manager";
    homepage = "https://github.com/Vladimir-csp/uwsm";
    changelog = "https://github.com/Vladimir-csp/uwsm/releases/tag/v${finalAttrs.version}";
    mainProgram = "uwsm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnrtitor
      kai-tub
    ];
    platforms = lib.platforms.linux;
  };
})
