{ stdenv, fetchurl, buildPackages, lib, fetchpatch, texinfo
, # "newlib-nano" is what the official ARM embedded toolchain calls this build
  # configuration that prioritizes low space usage. We include it as a preset
  # for embedded projects striving for a similar configuration.
  nanoizeNewlib ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newlib";
  version = "4.3.0.20230120";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-g6Yqma9Z4465sMWO0JLuJNcA//Q6IsA+QzlVET7zUVA=";
  };

  patches = lib.optionals nanoizeNewlib [
    # https://bugs.gentoo.org/723756
    (fetchpatch {
      name = "newlib-3.3.0-no-nano-cxx.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/newlib/files/newlib-3.3.0-no-nano-cxx.patch?id=9ee5a1cd6f8da6d084b93b3dbd2e8022a147cfbf";
      sha256 = "sha256-S3mf7vwrzSMWZIGE+d61UDH+/SK/ao1hTPee1sElgco=";
    })
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    texinfo # for makeinfo
  ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [ "build" "target" ];
  # flags copied from https://community.arm.com/support-forums/f/compilers-and-libraries-forum/53310/gcc-arm-none-eabi-what-were-the-newlib-compilation-options
  # sort alphabetically
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"
  ] ++ (if !nanoizeNewlib then [
    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-c99-formats"
    "--enable-newlib-io-long-long"
    "--enable-newlib-reent-check-verify"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ] else [
    "--disable-newlib-fseek-optimization"
    "--disable-newlib-fvwrite-in-streamio"
    "--disable-newlib-supplied-syscalls"
    "--disable-newlib-unbuf-stream-opt"
    "--disable-newlib-wide-orient"
    "--disable-nls"
    "--enable-lite-exit"
    "--enable-newlib-global-atexit"
    "--enable-newlib-nano-formatted-io"
    "--enable-newlib-nano-malloc"
    "--enable-newlib-reent-check-verify"
    "--enable-newlib-reent-small"
    "--enable-newlib-retargetable-locking"
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

  meta = with lib; {
    description = "a C library intended for use on embedded systems";
    homepage = "https://sourceware.org/newlib/";
    # arch has "bsd" while gentoo has "NEWLIB LIBGLOSS GPL-2" while COPYING has "gpl2"
    # there are 5 copying files in total
    # COPYING
    # COPYING.LIB
    # COPYING.LIBGLOSS
    # COPYING.NEWLIB
    # COPYING3
    license = licenses.gpl2Plus;
  };
})
