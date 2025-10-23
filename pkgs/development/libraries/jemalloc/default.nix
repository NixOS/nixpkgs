{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autogen,
  autoconf,
  automake,
  # By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
  # then stops downstream builds (mariadb in particular) from detecting it. This
  # option should remove the prefix and give us a working jemalloc.
  # Causes segfaults with some software (ex. rustc), but defaults to true for backward
  # compatibility.
  stripPrefix ? stdenv.hostPlatform.isDarwin,
  disableInitExecTls ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jemalloc";
  version = "5.3.0-unstable-2025-09-12";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "jemalloc";
    rev = "c0889acb6c286c837530fdbeb96007b0dee8b776";
    hash = "sha256-lBNgvUhuiRPgzr8JC4zSSCT2KpDBktBVX72zfvAEHvo=";
  };

  patches = [
    # -O3 appears to introduce an unreproducibility where
    # `rtree_read.constprop.0` shows up in some builds but
    # not others, so we fall back to O2:
    ./o3-to-o2.patch
  ];

  nativeBuildInputs = [
    autogen
    autoconf
    automake
  ];

  # TODO: switch to autoreconfHook when updating beyond 5.3.0
  # https://github.com/jemalloc/jemalloc/issues/2346
  configureScript = "./autogen.sh";

  configureFlags = [
    "--with-version=${lib.versions.majorMinor finalAttrs.version}.0-0-g${finalAttrs.src.rev}"
    "--with-lg-vaddr=${with stdenv.hostPlatform; toString (if isILP32 then 32 else parsed.cpu.bits)}"
  ]
  # see the comment on stripPrefix
  ++ lib.optional stripPrefix "--with-jemalloc-prefix="
  ++ lib.optional disableInitExecTls "--disable-initial-exec-tls"
  # The upstream default is dependent on the builders' page size
  # https://github.com/jemalloc/jemalloc/issues/467
  # https://sources.debian.org/src/jemalloc/5.3.0-3/debian/rules/
  ++ [
    (
      if (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isLoongArch64) then
        "--with-lg-page=16"
      else
        "--with-lg-page=12"
    )
  ]
  # See https://github.com/jemalloc/jemalloc/issues/1997
  # Using a value of 48 should work on both emulated and native x86_64-darwin.
  ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "--with-lg-vaddr=48";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=array-bounds";

  # Tries to link test binaries binaries dynamically and fails
  doCheck = !stdenv.hostPlatform.isStatic;

  doInstallCheck = true;
  installCheckPhase = ''
    ! grep missing_version_try_git_fetch_tags $out/include/jemalloc/jemalloc.h
  '';

  # Parallel builds break reproducibility.
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://jemalloc.net/";
    description = "General purpose malloc(3) implementation";
    longDescription = ''
      malloc(3)-compatible memory allocator that emphasizes fragmentation
      avoidance and scalable concurrency support.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
  };
})
