{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  wrapWithXFileSearchPathHook,
  libx11,
  libxaw,
  libxft,
  libxkbfile,
  libxmu,
  libxrender,
  libxt,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xclock";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xclock";
    tag = "xclock-${finalAttrs.version}";
    hash = "sha256-ZgUb+iVO45Az/C+2YJ1TXxcTLk3zQjM1GGv2E69WNfo=";
  };

  patches = [
    # meson build system patch
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/app/xclock/-/commit/28e10bd26ac7e02fe8a4fb8016bb115f8d664032.patch";
      hash = "sha256-KdrS7VneJqwVPB+TRJoMmtR03Ju3PvvUMYfXz5tII6k=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxaw
    libxft
    libxkbfile
    libxmu
    libxrender
    libxt
    xorgproto
  ];

  mesonFlags = [
    (lib.mesonOption "appdefaultdir" "${placeholder "out"}/share/X11/app-defaults")
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xclock-(.*)" ]; };

  meta = {
    description = "analog / digital clock for X";
    longDescription = ''
      xclock is the classic X Window System clock utility. It displays the time in analog or digital
      form, continuously updated at a frequency which may be specified by the user.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xclock";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      mit
    ];
    mainProgram = "xclock";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
