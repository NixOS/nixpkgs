{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  xvfb-run,
  gtk4,
  libgee,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live-chart";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "live-chart";
    tag = finalAttrs.version;
    hash = "sha256-X/wdmKw381Fkjcvj7k2AmA/nXWKFFNx5KDNxeWEiqzs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    xvfb-run
  ];

  buildInputs = [
    gtk4
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Real-time charting library for Vala and GTK4 based on Cairo";
    homepage = "https://github.com/elementary/live-chart";
    license = lib.licenses.mit;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
})
