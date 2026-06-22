{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  libx11,
  libxcb,
  libxext,
  libxi,
  libxtst,
  libxcomposite,
  libxinerama,
  libxpresent,
  libxrandr,
  libxrender,
  libxxf86dga,
  libxxf86vm,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdpyinfo";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg";
    repo = "app/xdpyinfo";
    tag = "xdpyinfo-${finalAttrs.version}";
    hash = "sha256-zN2ViUJhrndqyLFCzcUi2DRg2K2q9eJXzHlUsMNmhNg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    libx11
    libxcb
    libxext
    libxi
    libxtst
    # optional deps
    libxcomposite
    libxinerama
    libxpresent
    libxrandr
    libxrender
    libxxf86dga
    libxxf86vm
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xdpyinfo-(.*)" ]; };

  meta = {
    description = "display information utility for X";
    longDescription = ''
      xdpyinfo is a utility for displaying information about an X server.
      It is used to examine the capabilities of a server, the predefined
      values for various parameters used in communicating between clients
      and the server, and the different types of screens, visuals, and X11
      protocol extensions that are available.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xdpyinfo";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xdpyinfo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
