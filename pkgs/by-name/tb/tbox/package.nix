{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tbox";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = "tbox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qrmlS2ympche4o0EquQWcy9+tP+WdqOhyRkN6SsSJLk=";
  };

  patches = [
    # Needed to build on Darwin at all: the 32-bit ARM assembly paths are
    # picked up on arm64, and the feature checks that would enable the POSIX
    # file API never succeed.
    ./darwin-arm64.patch
  ];

  # xmake's configure script probes every libc/POSIX function with -Werror and
  # adds "-target <arch>-apple-macos<version>", while the Nix compiler wrapper
  # adds "-mmacos-version-min".  The resulting -Woverriding-option warning makes
  # every feature check fail, which stubs out the platform APIs.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-overriding-option";

  configureFlags = [
    "--hash=y"
    "--charset=y"
    "--float=y"
    "--demo=n"
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./libtbox.pc.in} $out/lib/pkgconfig/libtbox.pc
  '';

  meta = {
    description = "Glib-like multi-platform c library";
    homepage = "https://tboox.top";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ wineee ];
  };
})
