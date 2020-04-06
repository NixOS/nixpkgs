{ stdenv
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
, langFortran
, langJava ? false, javaAwtGtk ? false, javaAntlr ? null, javaEcj ? null
, langGo
, langObjC
, langObjCpp
}:

assert cloog != null -> stdenv.lib.versionOlder version "5";
assert langJava -> stdenv.lib.versionOlder version "7";

let
  inherit (stdenv)
    buildPlatform hostPlatform targetPlatform
    lib;

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
      "--enable-sjlj-exceptions"
      "--disable-win32-registry"
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
    ] ++ lib.optionals crossMingw [
      "--enable-sjlj-exceptions"
      "--enable-hash-synchronization"
      "--enable-libssp"
      "--disable-nls"
      "--with-dwarf2"
      # To keep ABI compatibility with upstream mingw-w64
      "--enable-fully-dynamic-string"
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
          ++ lib.optional langFortran  "fortran"
          ++ lib.optional langJava     "java"
          ++ lib.optional langGo       "go"
          ++ lib.optional langObjC     "objc"
          ++ lib.optional langObjCpp   "obj-c++"
          ++ lib.optionals crossDarwin [ "objc" "obj-c++" ]
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

    # Optional features
    ++ lib.optional (isl != null) "--with-isl=${isl}"
    ++ lib.optionals (cloog != null) [
      "--with-cloog=${cloog}"
      "--disable-cloog-version-check"
      "--enable-cloog-backend=isl"
    ]

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

    ++ (import ../common/platform-flags.nix { inherit (stdenv) lib targetPlatform; })
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
  ;

in configureFlags
