{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  libx11,
  libxmu,
  mcpp,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xrdb";
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xrdb";
    tag = "xrdb-${finalAttrs.version}";
    hash = "sha256-XCi/E6tVaLYGRsMWJalCl1J8VIT4xV6KFuo+K//LQGY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorgproto
    libx11
    libxmu
  ];

  # replace gcc with mcpp as preprocessor to reduce the closure size
  # see https://github.com/NixOS/nixpkgs/issues/9480
  configureFlags = [ "--with-cpp=${lib.getExe mcpp}" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=xrdb-(.*)" ]; };

  meta = {
    description = "X resource database utility";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrdb";
    license = with lib.licenses; [
      hpndDec
      mitOpenGroup
    ];
    mainProgram = "xrdb";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
