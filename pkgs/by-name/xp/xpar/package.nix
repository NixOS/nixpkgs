{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpar";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "kspalaiologos";
    repo = "xpar";
    rev = finalAttrs.version;
    hash = "sha256-cvt5fXg3mKzh0GlL1qkA7G17p2ZA0PpFnE2cLYwlmUM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ nasm ];

  configureFlags = [
    "--disable-arch-native"
    "--enable-lto"
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 "--enable-x86-64"
  ++ lib.optional stdenv.hostPlatform.isAarch64 "--enable-aarch64";

  meta = {
    description = "Error/erasure code system guarding data integrity";
    homepage = "https://github.com/kspalaiologos/xpar";
    changelog = "https://github.com/kspalaiologos/xpar/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mrbenjadmin ];
    platforms = lib.platforms.all;
    mainProgram = "xpar";
  };
})
