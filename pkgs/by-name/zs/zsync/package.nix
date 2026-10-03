{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  perl,

  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsync";
  version = "0.6.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cph6";
    repo = "zsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HE9CwoFK6301rwwKY1zy+wvN1r6ODsecgClDGWKyB3s=";
  };

  sourceRoot = "${finalAttrs.src.name}/c";

  patches = [ ./c23.patch ];

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  # Suppress error "call to undeclared library function 'strcasecmp'" during compilation.
  # The function is found by the linker correctly, so this doesn't introduce any issues.
  # Also suppress errors that come from incompatible pointer types due to GCC 14 changes.
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-implicit-function-declaration"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      "-Wno-error=incompatible-pointer-types"
    ]
  );

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl ];

  doCheck = true;

  nativeCheckInputs = [ perl ];

  meta = {
    description = "File distribution system using the rsync algorithm";
    homepage = "https://github.com/cph6/zsync";
    changelog = "https://github.com/cph6/zsync/raw/refs/tags/${finalAttrs.src.tag}/c/NEWS";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [
      viric
      ryand56
    ];
    platforms = with lib.platforms; all;
    mainProgram = "zsync";
  };
})
