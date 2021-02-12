{ lib, stdenv
, targetPackages

, crossStageStatic, libcCross
, version

, gmp, mpfr, libmpc, libelf, isl
, cloog ? null

, enableLTO
, enableMultilib
, enablePlugin
, enableShared

, langC
, langCC
, langD ? false
, langFortran
, langJava ? false, javaAwtGtk ? false, javaAntlr ? null, javaEcj ? null
, langAda ? false
, langGo
, langObjC
, langObjCpp
, langJit
}:

assert cloog != null -> lib.versionOlder version "5";
assert langJava -> lib.versionOlder version "7";

# Note [Windows Exception Handling]
# sjlj (short jump long jump) exception handling makes no sense on x86_64,
# it's forcably slowing programs down as it produces a constant overhead.
# On x86_64 we have SEH (Structured Exception Handling) and we should use
# that. On i686, we do not have SEH, and have to use sjlj with dwarf2.
# Hence it's now conditional on x86_32 (i686 is 32bit).
#
# ref: https://stackoverflow.com/questions/15670169/what-is-difference-between-sjlj-vs-dwarf-vs-seh


let
  inherit (stdenv)
    buildPlatform hostPlatform targetPlatform;

  crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
  crossDarwin = targetPlatform != hostPlatform && targetPlatform.libc == "libSystem";

  crossConfigureFlags =
    # Ensure that -print-prog-name is able to find the correct programs.
    [
      "--with-as=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-as"
      "--with-ld=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-ld"
    ]
    ++ (if crossStageStatic then [
      "--disable-libssp"
      "--disable-nls"
      "--without-headers"
      "--disable-threads"
      "--disable-libgomp"
      "--disable-libquadmath"
      "--disable-shared"
      "--disable-libatomic" # requires libc
      "--disable-decimal-float" # requires libc
      "--disable-libmpx" # requires libc
    ] ++ lib.optionals crossMingw [
      "--with-headers=${lib.getDev libcCross}/include"
      "--with-gcc"
      "--with-gnu-as"
      "--with-gnu-ld"
      "--disable-debug"
      "--disable-win32-registry"
      "--enable-hash-synchronization"
      "--enable-libssp"
      "--disable-nls"
      # To keep ABI compatibility with upstream mingw-w64
      "--enable-fully-dynamic-string"
    ] ++ lib.optionals (crossMingw && targetPlatform.isx86_32) [
      # See Note [Windows Exception Handling]
      "--enable-sjlj-exceptions"
      "--with-dwarf2"
    ] else [
      (if crossDarwin then "--with-sysroot=${lib.getLib libcCross}/share/sysroot"
       else                "--with-headers=${lib.getDev libcCross}${libcCross.incdir or "/include"}")
      "--enable-__cxa_atexit"
      "--enable-long-long"
      "--enable-threads=${if targetPlatform.isUnix then "posix"
                          else if targetPlatform.isWindows then "mcf"
                          else "single"}"
      "--enable-nls"
      "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
    ] ++ lib.optionals (targetPlatform.libc == "uclibc" || targetPlatform.libc == "musl") [
      # libsanitizer requires netrom/netrom.h which is not
      # available in uclibc.
      "--disable-libsanitizer"
      # In uclibc cases, libgomp needs an additional '-ldl'
      # and as I don't know how to pass it, I disable libgomp.
      "--disable-libgomp"
    ] ++ lib.optionals (targetPlatform.libc == "musl") [
      # musl at least, disable: https://git.buildroot.net/buildroot/commit/?id=873d4019f7fb00f6a80592224236b3ba7d657865
      "--disable-libmpx"
    ] ++ lib.optional (targetPlatform.libc == "newlib") "--with-newlib"
      ++ lib.optional (targetPlatform.libc == "avrlibc") "--with-avrlibc"
    );

  configureFlags =
    # Basic dependencies
    [
      "--with-gmp-include=${gmp.dev}/include"
      "--with-gmp-lib=${gmp.out}/lib"
      "--with-mpfr-include=${mpfr.dev}/include"
      "--with-mpfr-lib=${mpfr.out}/lib"
      "--with-mpc=${libmpc}"
    ]
    ++ lib.optional (libelf != null) "--with-libelf=${libelf}"
    ++ lib.optional (!(crossMingw && crossStageStatic))
      "--with-native-system-header-dir=${lib.getDev stdenv.cc.libc}/include"

    # Basic configuration
    ++ [
      (lib.enableFeature enableLTO "lto")
      "--disable-libstdcxx-pch"
      "--without-included-gettext"
      "--with-system-zlib"
      "--enable-static"
      "--enable-languages=${
        lib.concatStrings (lib.intersperse ","
          (  lib.optional langC        "c"
          ++ lib.optional langCC       "c++"
          ++ lib.optional langD        "d"
          ++ lib.optional langFortran  "fortran"
          ++ lib.optional langJava     "java"
          ++ lib.optional langAda      "ada"
          ++ lib.optional langGo       "go"
          ++ lib.optional langObjC     "objc"
          ++ lib.optional langObjCpp   "obj-c++"
          ++ lib.optionals crossDarwin [ "objc" "obj-c++" ]
          ++ lib.optional langJit      "jit"
          )
        )
      }"
    ]

    ++ (if (enableMultilib || targetPlatform.isAvr)
      then ["--enable-multilib" "--disable-libquadmath"]
      else ["--disable-multilib"])
    ++ lib.optional (!enableShared) "--disable-shared"
    ++ [
      (lib.enableFeature enablePlugin "plugin")
    ]

    # Support -m32 on powerpc64le
    ++ lib.optional (targetPlatform.system == "powerpc64le-linux")
      "--enable-targets=powerpcle-linux"

    # Optional features
    ++ lib.optional (isl != null) "--with-isl=${isl}"
    ++ lib.optionals (cloog != null) [
      "--with-cloog=${cloog}"
      "--disable-cloog-version-check"
      "--enable-cloog-backend=isl"
    ]

    # Ada options
    ++ lib.optional langAda "--enable-libada"

    # Java options
    ++ lib.optionals langJava [
      "--with-ecj-jar=${javaEcj}"

      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home"
      "--with-java-home=\${prefix}/lib/jvm/jre"
    ]
    ++ lib.optional javaAwtGtk "--enable-java-awt=gtk"
    ++ lib.optional (langJava && javaAntlr != null) "--with-antlr-jar=${javaAntlr}"

    ++ (import ../common/platform-flags.nix { inherit (stdenv)  targetPlatform; inherit lib; })
    ++ lib.optionals (targetPlatform != hostPlatform) crossConfigureFlags
    ++ lib.optional (targetPlatform != hostPlatform) "--disable-bootstrap"

    # Platform-specific flags
    ++ lib.optional (targetPlatform == hostPlatform && targetPlatform.isx86_32) "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
    ++ lib.optionals hostPlatform.isSunOS [
      "--enable-long-long" "--enable-libssp" "--enable-threads=posix" "--disable-nls" "--enable-__cxa_atexit"
      # On Illumos/Solaris GNU as is preferred
      "--with-gnu-as" "--without-gnu-ld"
    ]
    ++ lib.optionals (targetPlatform == hostPlatform && targetPlatform.libc == "musl") [
      "--disable-libsanitizer"
      "--disable-symvers"
      "libat_cv_have_ifunc=no"
      "--disable-gnu-indirect-function"
    ]
    ++ lib.optionals langJit [
      "--enable-host-shared"
    ]
    ++ lib.optionals (langD) [
      "--with-target-system-zlib=yes"
    ]
    # Make -fcommon default on gcc10
    # TODO: fix all packages (probably 100+) and remove that
    ++ lib.optional (version >= "10.1.0") "--with-specs=%{!fno-common:%{!fcommon:-fcommon}}"
  ;

in configureFlags
