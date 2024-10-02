{
  stdenv,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  meson,
  ninja,
  scdoc,
  pkg-config,
  nix-update-script,
  bash,
  dmenu,
  libnotify,
  newt,
  python3Packages,
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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-BtzW0jyYAVGjSBlocgkGHgY3JQUpWizDaSa2YBIX2Bs=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
    scdoc
  ];

  propagatedBuildInputs = [
    util-linux # waitpid
    newt # whiptail
    libnotify # notify
    bash # sh
    python
  ] ++ (lib.optionals uuctlSupport [ dmenu ]);

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    (lib.mapAttrsToList lib.mesonEnable {
      "uwsm-app" = uwsmAppSupport;
      "fumon" = fumonSupport;
      "uuctl" = uuctlSupport;
      "man-pages" = true;
    })
    (lib.mesonOption "python-bin" python.interpreter)
  ];

  postInstall =
    let
      wrapperArgs = ''
        --prefix PATH : "${lib.makeBinPath finalAttrs.propagatedBuildInputs}"
      '';
    in
    ''
      wrapProgram $out/bin/uwsm ${wrapperArgs}
      ${lib.optionalString uuctlSupport ''
        wrapProgram $out/bin/uuctl ${wrapperArgs}
      ''}
      ${lib.optionalString uwsmAppSupport ''
        wrapProgram $out/bin/uwsm-app ${wrapperArgs}
      ''}
      ${lib.optionalString fumonSupport ''
        wrapProgram $out/bin/fumon ${wrapperArgs}
      ''}
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
