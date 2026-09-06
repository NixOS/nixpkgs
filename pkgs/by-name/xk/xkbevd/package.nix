{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  bison,
  pkg-config,
  util-macros,
  libx11,
  libxkbfile,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xkbevd";
  version = "1.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbevd";
    tag = "xkbevd-${finalAttrs.version}";
    hash = "sha256-n/detXvtRvysc5pjFc0Q27yLC2QsNUBo9AIXYkUG4PQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    pkg-config
    util-macros
  ];

  buildInputs = [
    util-macros # unused dependency but the build fails if pkg-config can't find it
    libx11
    libxkbfile
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xkbevd-(.*)" ]; };

  meta = {
    description = "XKB event daemon";
    longDescription = ''
      The xkbevd event daemon listens for specified XKB events and executes requested commands if
      they occur. The configuration file consists of a list of event specification/action pairs
      and/or variable definitions.
      This command is very raw and is therefore only partially implemented; it is a rough prototype
      for developers, not a general purpose tool for end users.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xkbevd";
    license = lib.licenses.hpnd;
    mainProgram = "xkbevd";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
