{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  versionCheckHook,
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
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xclock";
    tag = "xclock-${finalAttrs.version}";
    hash = "sha256-sytAl9vXBdxjTM0NnAgRNK34yqn/6zJeCQ/9bH3xaOc=";
  };

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

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
    maintainers = with lib.maintainers; [ booxter ];
    platforms = lib.platforms.unix;
  };
})
