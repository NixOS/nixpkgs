{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  scdoc,
  pkg-config,
  nix-update-script,
  dmenu,
  libnotify,
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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-M2j7l5XTSS2IzaJofAHct1tuAO2A9Ps9mCgAWKEvzoE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libnotify
    util-linux
  ] ++ (lib.optionals uuctlSupport [ dmenu ]);

  propagatedBuildInputs = [ python ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    (lib.mapAttrsToList lib.mesonEnable {
      "uwsm-app" = uwsmAppSupport;
      "fumon" = fumonSupport;
      "uuctl" = uuctlSupport;
      "man-pages" = true;
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Universal wayland session manager";
    homepage = "https://github.com/Vladimir-csp/uwsm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    platforms = lib.platforms.linux;
  };
})
