{ lib
, stdenv
, buildPackages
, fetchurl
, gitUpdater
, linuxHeaders
, libiconvReal
, extraConfig ? ""
}:

let
  isCross = (stdenv.buildPlatform != stdenv.hostPlatform);
  configParser = ''
    function parseconfig {
        set -x
        while read LINE; do
            NAME=`echo "$LINE" | cut -d \  -f 1`
            OPTION=`echo "$LINE" | cut -d \  -f 2`

            if test -z "$NAME"; then
                continue
            fi

            echo "parseconfig: removing $NAME"
            sed -i /^$NAME=/d .config

            #if test "$OPTION" != n; then
                echo "parseconfig: setting $NAME=$OPTION"
                echo "$NAME=$OPTION" >> .config
            #fi
        done
        set +x
    }
  '';

  # UCLIBC_SUSV4_LEGACY defines 'tmpnam', needed for gcc libstdc++ builds.
  nixConfig = ''
    RUNTIME_PREFIX "/"
    DEVEL_PREFIX "/"
    UCLIBC_HAS_WCHAR y
    UCLIBC_HAS_FTW y
    UCLIBC_HAS_RPC y
    DO_C99_MATH y
    UCLIBC_HAS_PROGRAM_INVOCATION_NAME y
    UCLIBC_HAS_RESOLVER_SUPPORT y
    UCLIBC_SUSV4_LEGACY y
    UCLIBC_HAS_THREADS_NATIVE y
    KERNEL_HEADERS "${linuxHeaders}/include"
  '' + lib.optionalString (stdenv.hostPlatform.gcc.float or "" == "soft") ''
    UCLIBC_HAS_FPU n
  '' + lib.optionalString (stdenv.isAarch32 && isCross) ''
    CONFIG_ARM_EABI y
    ARCH_WANTS_BIG_ENDIAN n
    ARCH_BIG_ENDIAN n
    ARCH_WANTS_LITTLE_ENDIAN y
    ARCH_LITTLE_ENDIAN y
    UCLIBC_HAS_FPU n
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uclibc-ng";
  version = "1.0.50";

  src = fetchurl {
    url = "https://downloads.uclibc-ng.org/releases/${finalAttrs.version}/uClibc-ng-${finalAttrs.version}.tar.xz";
    hash = "sha256-rthnJR9II6dOpeOjmT06fBIygKvhXjjcIGdww5aPIc8=";
  };

  # 'ftw' needed to build acl, a coreutils dependency
  configurePhase = ''
    make defconfig
    ${configParser}
    cat << EOF | parseconfig
    ${nixConfig}
    ${extraConfig}
    ${stdenv.hostPlatform.uclibc.extraConfig or ""}
    EOF
    ( set +o pipefail; yes "" | make oldconfig )
  '';

  hardeningDisable = [ "stackprotector" ];

  # Cross stripping hurts.
  dontStrip = isCross;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    "TARGET_ARCH=${stdenv.hostPlatform.linuxArch}"
    "VERBOSE=1"
  ] ++ lib.optionals (isCross) [
    "CROSS=${stdenv.cc.targetPrefix}"
  ];

  # `make libpthread/nptl/sysdeps/unix/sysv/linux/lowlevelrwlock.h`:
  # error: bits/sysnum.h: No such file or directory
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    make $makeFlags PREFIX=$out VERBOSE=1 install
    (cd $out/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
    # libpthread.so may not exist, so I do || true
    sed -i s@/lib/@$out/lib/@g $out/lib/libc.so $out/lib/libpthread.so || true

    runHook postInstall
  '';

  passthru = {
    # Derivations may check for the existance of this attribute, to know what to
    # link to.
    libiconv = libiconvReal;

    updateScript = gitUpdater {
      url = "https://git.uclibc-ng.org/git/uclibc-ng.git";
      rev-prefix = "v";
    };
  };

  meta = {
    homepage = "https://uclibc-ng.org";
    description = "Embedded C library";
    longDescription = ''
      uClibc-ng is a small C library for developing embedded Linux systems. It
      is much smaller than the GNU C Library, but nearly all applications
      supported by glibc also work perfectly with uClibc-ng.

      Porting applications from glibc to uClibc-ng typically involves just
      recompiling the source code. uClibc-ng supports shared libraries and
      threading. It currently runs on standard Linux and MMU-less (also known as
      uClinux) systems with support for Aarch64, Alpha, ARC, ARM, AVR32,
      Blackfin, CRIS, C-Sky, C6X, FR-V, H8/300, HPPA, i386, IA64, KVX, LM32,
      M68K/Coldfire, Metag, Microblaze, MIPS, MIPS64, NDS32, NIOS2, OpenRISC,
      PowerPC, RISCV64, Sparc, Sparc64, SuperH, Tile, X86_64 and XTENSA
      processors. Alpha, FR-V, HPPA, IA64, LM32, NIOS2, Tile and Sparc64 are
      experimental and need more testing.
    '';
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ rasendubi AndersonTorres ];
    platforms = lib.platforms.linux;
    badPlatforms = lib.platforms.aarch64;
  };
})
