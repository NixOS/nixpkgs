{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  # base build deps
  meson,
  pkg-config,
  ninja,
  # docs build deps
  python3,
  doxygen,
  graphviz,
  # GI build deps
  gobject-introspection,
  # runtime deps
  glib,
  systemd,
  lua5_4,
  pipewire,
  # options
  enableDocs ? true,
  enableGI ? true,
}:

stdenv.mkDerivation rec {
  pname = "wireplumber";
  version = "0.5.13";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional enableDocs "doc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "wireplumber";
    rev = version;
    hash = "sha256-iQpMT01mRroaA48spA11zdb47L5AcVmigE4nJuJRaUo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ]
  ++ lib.optionals enableDocs [
    graphviz
  ]
  ++ lib.optionals enableGI [
    gobject-introspection
  ]
  ++ lib.optionals (enableDocs || enableGI) [
    doxygen
    (python3.pythonOnBuildForHost.withPackages (
      ps:
      with ps;
      lib.optionals enableDocs [
        sphinx
        sphinx-rtd-theme
        breathe
      ]
      ++ lib.optionals enableGI [ lxml ]
    ))
  ];

  buildInputs = [
    glib
    systemd
    lua5_4
    pipewire
  ];

  mesonFlags = [
    (lib.mesonBool "system-lua" true)
    (lib.mesonEnable "elogind" false)
    (lib.mesonEnable "doc" enableDocs)
    (lib.mesonEnable "introspection" enableGI)
    (lib.mesonBool "systemd-system-service" true)
    (lib.mesonOption "systemd-system-unit-dir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular session / policy manager for PipeWire";
    homepage = "https://pipewire.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
  };
}
