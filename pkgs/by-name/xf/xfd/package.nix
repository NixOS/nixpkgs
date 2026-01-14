{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  wrapWithXFileSearchPathHook,
  fontconfig,
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
  pname = "xfd";
  version = "1.1.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xfd";
    tag = "xfd-${finalAttrs.version}";
    hash = "sha256-8kkoJILNlVgDIV029mF3err6es5V001FQqUnTtD9/LQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    fontconfig
    libxaw
    libxft
    libxkbfile
    libxmu
    libxrender
    libxt
    xorgproto
  ];

  installFlags = [ "appdefaultdir=$out/share/X11/app-defaults" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xfd-(.*)" ]; };

  meta = {
    description = "X font display utility, using either the X11 core protocol or libXft2.";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xfd";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xfd";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
