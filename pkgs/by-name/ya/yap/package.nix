{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  R,
  readline,
  gmp,
  zlib,
  librdf_raptor2,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "yap";
  version = "7.6.0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "vscosta";
    repo = "yap";
    rev = "010bb5e48d2f4fbdc0c47ae9faa830a179b3c31b";
    hash = "sha256-ojhporq7vCEtdwCIRHwzjpc6dbFFXAgF+p6M7eL3JIE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    R
  ];

  buildInputs = [
    readline
    gmp
    zlib
    librdf_raptor2
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_READLINE" true)
    (lib.cmakeBool "WITH_R" true)
    (lib.cmakeBool "WITH_Raptor2" true)
    (lib.cmakeBool "WITH_CUDD" false)
    (lib.cmakeBool "WITH_Gecode" false)
  ];

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libYap.a(pl-dtoa.o):/build/yap-6.3.3/H/pl-yap.h:230: multiple definition of `ATOM_';
  #     libYap.a(pl-buffer.o):/build/yap-6.3.3/H/pl-yap.h:230: first defined here
  env.NIX_CFLAGS_COMPILE = "-fpermissive -fcommon";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    # linux 32 bit build fails.
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || !stdenv.hostPlatform.is64bit;
    homepage = "https://github.com/vscosta/yap";
    description = "ISO-compatible high-performance Prolog compiler";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.linux;
  };
}
