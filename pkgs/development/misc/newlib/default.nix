{ stdenv, fetchurl, buildPackages, lib, fetchpatch
, # "newlib-nano" is what the official ARM embedded toolchain calls this build
  # configuration that prioritizes low space usage. We include it as a preset
  # for embedded projects striving for a similar configuration.
  nanoizeNewlib ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newlib";
  version = "4.1.0";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${finalAttrs.version}.tar.gz";
    sha256 = "0m01sjjyj0ib7bwlcrvmk1qkkgd66zf1dhbw716j490kymrf75pj";
  };

  patches = lib.optionals nanoizeNewlib [
    # https://bugs.gentoo.org/723756
    (fetchpatch {
      name = "newlib-3.3.0-no-nano-cxx.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/newlib/files/newlib-3.3.0-no-nano-cxx.patch?id=9ee5a1cd6f8da6d084b93b3dbd2e8022a147cfbf";
      sha256 = "sha256-S3mf7vwrzSMWZIGE+d61UDH+/SK/ao1hTPee1sElgco=";
    })
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [ "build" "target" ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-retargetable-locking"
  ] ++ (if !nanoizeNewlib then [
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
  ] else [
    "--enable-newlib-reent-small"
    "--disable-newlib-fvwrite-in-streamio"
    "--disable-newlib-fseek-optimization"
    "--disable-newlib-wide-orient"
    "--enable-newlib-nano-malloc"
    "--disable-newlib-unbuf-stream-opt"
    "--enable-lite-exit"
    "--enable-newlib-global-atexit"
    "--enable-newlib-nano-formatted-io"
  ]);

  dontDisableStatic = true;

  # apply necessary nano changes from https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/manifest/copy_nano_libraries.sh?rev=4c50be6ccb9c4205a5262a3925317073&hash=1375A7B0A1CD0DB9B9EB0D2B574ADF66
  postInstall = lib.optionalString nanoizeNewlib ''
    mkdir -p $out${finalAttrs.passthru.incdir}/newlib-nano
    cp $out${finalAttrs.passthru.incdir}/newlib.h $out${finalAttrs.passthru.incdir}/newlib-nano/

    (
      cd $out${finalAttrs.passthru.libdir}

      for f in librdimon.a libc.a libg.a; do
        cp "$f" "''${f%%\.a}_nano.a"
      done
    )
  '';

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
})
