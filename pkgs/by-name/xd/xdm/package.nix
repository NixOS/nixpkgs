{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  wrapWithXFileSearchPathHook,
  libx11,
  libxau,
  libxaw,
  libxcrypt,
  libxdmcp,
  libxext,
  libxft,
  libxinerama,
  libxmu,
  libxpm,
  libxrender,
  libxt,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdm";
  version = "1.1.17";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg";
    repo = "app/xdm";
    tag = "xdm-${finalAttrs.version}";
    hash = "sha256-PhMctvL+Vp9uNmTtowMHzkoekieVCgNZCfUZ1XpjpyY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxau
    libxaw
    libxcrypt
    libxdmcp
    libxext
    libxft
    libxinerama
    libxmu
    libxpm
    libxrender
    libxt
  ];

  configureFlags = [
    "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
  ]
  # checking for /dev/urandom... configure: error: cannot check for file existence when cross compiling
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_file__dev_urandom=true"
    "ac_cv_file__dev_random=true"
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xdm-(.*)" ]; };

  meta = {
    description = "X Display Manager with support for XDMCP, host chooser";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xdm";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      x11
      bsd3ClauseTso
      bsd2
    ];
    mainProgram = "xdm";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
