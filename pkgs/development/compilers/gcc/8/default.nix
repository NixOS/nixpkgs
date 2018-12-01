{ stdenv, targetPackages, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langGo ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man)
, gmp, mpfr, libmpc, gettext, which
, libelf                      # optional, for link-time optimizations (LTO)
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, crossStageStatic ? false
, # Strip kills static libs of other archs (hence no cross)
  stripped ? stdenv.hostPlatform == stdenv.buildPlatform
          && stdenv.targetPlatform == stdenv.hostPlatform
, gnused ? null
, cloog # unused; just for compat with gcc4, as we override the parameter on some places
, buildPackages
}:

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert stdenv.hostPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

with stdenv.lib;
with builtins;

let version = "8.2.0";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
         optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      /* ++ optional (hostPlatform != buildPlatform) (fetchpatch { # XXX: Refine when this should be applied
        url = "https://git.busybox.net/buildroot/plain/package/gcc/${version}/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
        sha256 = ""; # TODO: uncomment and check hash when available.
      }) */
      ++ optional langFortran ../gfortran-driving.patch
      ++ optional (targetPlatform.libc == "musl" && targetPlatform.isPower) ../ppc-musl.patch
      ++ optional (targetPlatform.libc == "musl") ../libgomp-dont-force-initial-exec.patch;

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    crossDarwin = targetPlatform != hostPlatform && targetPlatform.libc == "libSystem";
    crossConfigureFlags =
      # Ensure that -print-prog-name is able to find the correct programs.
      [ "--with-as=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-as"
        "--with-ld=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-ld" ] ++
      (if crossMingw && crossStageStatic then [
        "--with-headers=${libcCross}/include"
        "--with-gcc"
        "--with-gnu-as"
        "--with-gnu-ld"
        "--with-gnu-ld"
        "--disable-shared"
        "--disable-nls"
        "--disable-debug"
        "--enable-sjlj-exceptions"
        "--enable-threads=win32"
        "--disable-win32-registry"
        "--disable-libmpx" # requires libc
      ] else if crossStageStatic then [
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
      ] else [
        (if crossDarwin then "--with-sysroot=${getLib libcCross}/share/sysroot"
         else                "--with-headers=${getDev libcCross}${libcCross.incdir or "/include"}")
        "--enable-__cxa_atexit"
        "--enable-long-long"
      ] ++
        (if crossMingw then [
          "--enable-threads=win32"
          "--enable-sjlj-exceptions"
          "--enable-hash-synchronization"
          "--enable-libssp"
          "--disable-nls"
          "--with-dwarf2"
          # To keep ABI compatibility with upstream mingw-w64
          "--enable-fully-dynamic-string"
        ] else
          optionals (targetPlatform.libc == "uclibc" || targetPlatform.libc == "musl") [
            # libsanitizer requires netrom/netrom.h which is not
            # available in uclibc.
            "--disable-libsanitizer"
            # In uclibc cases, libgomp needs an additional '-ldl'
            # and as I don't know how to pass it, I disable libgomp.
            "--disable-libgomp"
            # musl at least, disable: https://git.buildroot.net/buildroot/commit/?id=873d4019f7fb00f6a80592224236b3ba7d657865
            "--disable-libmpx"
          ]
          ++ optional (targetPlatform.libc == "newlib") "--with-newlib"
          ++ optional (targetPlatform.libc == "avrlibc") "--with-avrlibc"
          ++ [
            "--enable-threads=${if targetPlatform.isUnix then "posix"
                                else if targetPlatform.isWindows then "win32"
                                else "single"}"
            "--enable-nls"
            "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
        ]));
    stageNameAddon = if crossStageStatic then "-stage-static" else "-stage-final";
    crossNameAddon = if targetPlatform != hostPlatform then "-${targetPlatform.config}" + stageNameAddon else "";

    bootstrap = targetPlatform == hostPlatform;

in

stdenv.mkDerivation ({
  name = "${name}${if stripped then "" else "-debug"}-${version}" + crossNameAddon;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "10007smilswiiv2ymazr3b6x2i933c0ycxrr529zh4r6p823qv0r";
  };

  inherit patches;

  outputs = [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" "pie" ];

  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  prePatch = stdenv.lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c \
      --replace 'if (stdinc)' 'if (0)'

    substituteInPlace libgcc/config/t-slibgcc-darwin \
      --replace "-install_name @shlib_slibdir@/\$(SHLIB_INSTALL_NAME)" "-install_name $lib/lib/\$(SHLIB_INSTALL_NAME)"

    substituteInPlace libgfortran/configure \
      --replace "-install_name \\\$rpath/\\\$soname" "-install_name $lib/lib/\\\$soname"
  '';

  postPatch = ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done
  '' + (
    if targetPlatform != hostPlatform || stdenv.cc.libc != null then
      # On NixOS, use the right path to the dynamic linker instead of
      # `/lib/ld*.so'.
      let
        libc = if libcCross != null then libcCross else stdenv.cc.libc;
      in
        (
        '' echo "fixing the \`GLIBC_DYNAMIC_LINKER', \`UCLIBC_DYNAMIC_LINKER', and \`MUSL_DYNAMIC_LINKER' macros..."
           for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
           do
             grep -q _DYNAMIC_LINKER "$header" || continue
             echo "  fixing \`$header'..."
             sed -i "$header" \
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g' \
                 -e 's|define[[:blank:]]*MUSL_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define MUSL_DYNAMIC_LINKER\1 "${libc.out}\2"|g'
           done
        ''
        + stdenv.lib.optionalString (targetPlatform.libc == "musl")
        ''
            sed -i gcc/config/linux.h -e '1i#undef LOCAL_INCLUDE_DIR'
        ''
        )
    else "");

  inherit noSysDirs staticCompiler crossStageStatic
    libcCross crossMingw;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl);

  # For building runtime libs
  depsBuildTarget =
    if hostPlatform == buildPlatform then [
      targetPackages.stdenv.cc.bintools # newly-built gcc will be used
    ] else assert targetPlatform == hostPlatform; [ # build != host == target
      stdenv.cc
    ];

  buildInputs = [
    gmp mpfr libmpc libelf
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ] ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional hostPlatform.isDarwin gnused)
    ;

  NIX_LDFLAGS = stdenv.lib.optionalString  hostPlatform.isSunOS "-lm -ldl";

  preConfigure = stdenv.lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
    export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
    export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
    export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
    export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
  '';

  dontDisableStatic = true;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";

  configureFlags =
    # Basic dependencies
    [
      "--with-gmp-include=${gmp.dev}/include"
      "--with-gmp-lib=${gmp.out}/lib"
      "--with-mpfr-include=${mpfr.dev}/include"
      "--with-mpfr-lib=${mpfr.out}/lib"
      "--with-mpc=${libmpc}"
    ] ++
    optional (libelf != null) "--with-libelf=${libelf}" ++
    optional (!(crossMingw && crossStageStatic))
      "--with-native-system-header-dir=${getDev stdenv.cc.libc}/include" ++

    # Basic configuration
    [
      "--enable-lto"
      "--disable-libstdcxx-pch"
      "--without-included-gettext"
      "--with-system-zlib"
      "--enable-static"
      "--enable-languages=${
        concatStrings (intersperse ","
          (  optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langGo       "go"
          ++ optional langObjC     "objc"
          ++ optional langObjCpp   "obj-c++"
          ++ optionals crossDarwin [ "objc" "obj-c++" ]
          )
        )
      }"
    ] ++

    (if (enableMultilib || targetPlatform.isAvr)
      then ["--enable-multilib" "--disable-libquadmath"]
      else ["--disable-multilib"]) ++
    optional (!enableShared) "--disable-shared" ++
    (if enablePlugin
      then ["--enable-plugin"]
      else ["--disable-plugin"]) ++

    # Optional features
    optional (isl != null) "--with-isl=${isl}" ++

    (import ../common/platform-flags.nix { inherit (stdenv) lib targetPlatform; }) ++
    optional (targetPlatform != hostPlatform) crossConfigureFlags ++
    optional (!bootstrap) "--disable-bootstrap" ++

    # Platform-specific flags
    optional (targetPlatform == hostPlatform && targetPlatform.isi686) "--with-arch=i686" ++
    optionals hostPlatform.isSunOS [
      "--enable-long-long" "--enable-libssp" "--enable-threads=posix" "--disable-nls" "--enable-__cxa_atexit"
      # On Illumos/Solaris GNU as is preferred
      "--with-gnu-as" "--without-gnu-ld"
    ]
    ++ optionals (targetPlatform == hostPlatform && targetPlatform.libc == "musl") [
      "--disable-libsanitizer"
      "--disable-symvers"
      "libat_cv_have_ifunc=no"
      "--disable-gnu-indirect-function"
    ]
  ;

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (bootstrap && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  dontStrip = !stripped;

  installTargets =
    if stripped
    then "install-strip"
    else "install";

  # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Likewise, the LTO code doesn't find zlib.
  #
  # Cross-compiling, we need gcc not to read ./specs in order to build the g++
  # compiler (after the specs for the cross-gcc are created). Having
  # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

  CPATH = optionals (targetPlatform == hostPlatform) (makeSearchPathOutput "dev" "include" ([]
    ++ optional (zlib != null) zlib
  ));

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath (optional (zlib != null) zlib));


  EXTRA_TARGET_LDFLAGS = optionals
    (targetPlatform != hostPlatform && libcCross != null)
    ([
      "-Wl,-L${libcCross.out}${libcCross.libdir or "/lib"}"
    ] ++ (if crossStageStatic then [
        "-B${libcCross.out}${libcCross.libdir or "/lib"}"
      ] else [
        "-Wl,-rpath,${libcCross.out}${libcCross.libdir or "/lib"}"
        "-Wl,-rpath-link,${libcCross.out}${libcCross.libdir or "/lib"}"
    ]));

  passthru = {
    inherit langC langCC langObjC langObjCpp langFortran langGo version;
    isGNU = true;
  };

  enableParallelBuilding = true;
  inherit enableMultilib;

  inherit (stdenv) is64bit;

  meta = {
    homepage = https://gcc.gnu.org/;
    license = stdenv.lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}"
      + (if stripped then "" else " (with debugging info)");

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as
      libraries for these languages (libstdc++, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = with stdenv.lib.maintainers; [ synthetica ];

    platforms =
      stdenv.lib.platforms.linux ++
      stdenv.lib.platforms.freebsd ++
      stdenv.lib.platforms.illumos ++
      stdenv.lib.platforms.darwin;
  };
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
)
