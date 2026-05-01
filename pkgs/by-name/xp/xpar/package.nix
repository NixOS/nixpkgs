{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpar";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "iczelia";
    repo = "xpar";
    rev = finalAttrs.version;
    hash = "sha256-FCYZl8tllGvgoIE/u9lpQJANOfB7phyOegXk82EOzzM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ nasm ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    # for LTO
    export AR="${stdenv.cc.targetPrefix}gcc-ar"
    export NM="${stdenv.cc.targetPrefix}gcc-nm"
    export RANLIB="${stdenv.cc.targetPrefix}gcc-ranlib"
  '';

  configureFlags = [
    "--disable-arch-native"
    "--enable-lto"
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 "--enable-x86-64"
  ++ lib.optional stdenv.hostPlatform.isAarch64 "--enable-aarch64";

  meta = {
    description = "Error/erasure code system guarding data integrity";
    homepage = "https://github.com/iczelia/xpar";
    changelog = "https://github.com/iczelia/xpar/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mrbenjadmin ];
    platforms = lib.platforms.all;
    mainProgram = "xpar";
  };
})
