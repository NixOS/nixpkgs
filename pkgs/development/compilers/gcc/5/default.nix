{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.isDarwin
, langObjCpp ? stdenv.isDarwin
, langJava ? false
, langAda ? false
, langVhdl ? false
, langGo ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which
, libelf                      # optional, for link-time optimizations (LTO)
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null
, gtk ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, x11Support ? langJava
, gnatboot ? null
, enableMultilib ? false
, enablePlugin ? true             # whether to support user-supplied plug-ins
, name ? "gcc"
, cross ? null
, binutilsCross ? null
, libcCross ? null
, crossStageStatic ? true
, gnat ? null
, libpthread ? null, libpthreadCross ? null  # required for GNU/Hurd
, stripped ? true
, gnused ? null
, binutils ? null
, cloog # unused; just for compat with gcc4, as we override the parameter on some places
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'
assert langAda      -> gnatboot != null;
assert langVhdl     -> gnat != null;

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert stdenv.isDarwin -> gnused != null;

# Need c++filt on darwin
assert stdenv.isDarwin -> binutils != null;

# The go frontend is written in c++
assert langGo -> langCC;

with stdenv.lib;
with builtins;

let version = "5.3.0";

    # Whether building a cross-compiler for GNU/Hurd.
    crossGNU = cross != null && cross.config == "i586-pc-gnu";

    enableParallelBuilding = true;

    patches =
      [ ../use-source-date-epoch.patch ]
      ++ optional (cross != null) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
      # target libraries and tools.
      ++ optional langAda ../gnat-cflags.patch
      ++ optional langFortran ../gfortran-driving.patch;

    javaEcj = fetchurl {
      # The `$(top_srcdir)/ecj.jar' file is automatically picked up at
      # `configure' time.

      # XXX: Eventually we might want to take it from upstream.
      url = "ftp://sourceware.org/pub/java/ecj-4.3.jar";
      sha256 = "0jz7hvc0s6iydmhgh5h2m15yza7p2rlss2vkif30vm9y77m97qcx";
    };

    # Antlr (optional) allows the Java `gjdoc' tool to be built.  We want a
    # binary distribution here to allow the whole chain to be bootstrapped.
    javaAntlr = fetchurl {
      url = http://www.antlr.org/download/antlr-4.4-complete.jar;
      sha256 = "02lda2imivsvsis8rnzmbrbp8rh1kb8vmq4i67pqhkwz7lf8y6dz";
    };

    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xproto renderproto xextproto inputproto randrproto
    ];

    javaAwtGtk = langJava && x11Support;

    /* Platform flags */
    platformFlags = let
        gccArch = stdenv.platform.gcc.arch or null;
        gccCpu = stdenv.platform.gcc.cpu or null;
        gccAbi = stdenv.platform.gcc.abi or null;
        gccFpu = stdenv.platform.gcc.fpu or null;
        gccFloat = stdenv.platform.gcc.float or null;
        gccMode = stdenv.platform.gcc.mode or null;
      in []
        ++ optional (gccArch != null) "--with-arch=${gccArch}"
        ++ optional (gccCpu != null) "--with-cpu=${gccCpu}"
        ++ optional (gccAbi != null) "--with-abi=${gccAbi}"
        ++ optional (gccFpu != null) "--with-fpu=${gccFpu}"
        ++ optional (gccFloat != null) "--with-float=${gccFloat}"
        ++ optional (gccMode != null) "--with-mode=${gccMode}"
      ;

    /* Cross-gcc settings */
    crossMingw = cross != null && cross.libc == "msvcrt";
    crossDarwin = cross != null && cross.libc == "libSystem";
    crossConfigureFlags = let
        gccArch = stdenv.cross.gcc.arch or null;
        gccCpu = stdenv.cross.gcc.cpu or null;
        gccAbi = stdenv.cross.gcc.abi or null;
        gccFpu = stdenv.cross.gcc.fpu or null;
        gccFloat = stdenv.cross.gcc.float or null;
        gccMode = stdenv.cross.gcc.mode or null;
      in [
        "--target=${cross.config}"
      ] ++ optional (gccArch != null) "--with-arch=${gccArch}"
        ++ optional (gccCpu != null) "--with-cpu=${gccCpu}"
        ++ optional (gccAbi != null) "--with-abi=${gccAbi}"
        ++ optional (gccFpu != null) "--with-fpu=${gccFpu}"
        ++ optional (gccFloat != null) "--with-float=${gccFloat}"
        ++ optional (gccMode != null) "--with-mode=${gccMode}"
        ++ (if crossMingw && crossStageStatic then [
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
          ] else if crossStageStatic then [
            "--disable-libssp"
            "--disable-nls"
            "--without-headers"
            "--disable-threads "
            "--disable-libgomp "
            "--disable-libquadmath"
            "--disable-shared"
            "--disable-libatomic" # libatomic requires libc
            "--disable-decimal-float" # libdecnumber requires libc
          ] else [
              "--enable-__cxa_atexit"
              "--enable-long-long"
            ] ++ (optionals (crossMingw || crossDarwin) [
              "--with-as=${binutilsCross}/bin/${cross.config}-as"
              "--with-ld=${binutilsCross}/bin/${cross.config}-ld"
            ]) ++ (if crossDarwin
              then [ "--with-sysroot=${libcCross}/share/sysroot" ]
              else [ "--with-headers=${libcCross}/include" ]
              # Ensure that -print-prog-name is able to find the correct programs.
            ) ++ (if crossMingw then [
                "--enable-threads=win32"
                "--enable-sjlj-exceptions"
                "--enable-hash-synchronization"
                "--disable-libssp"
                "--disable-nls"
                "--with-dwarf2"
                # I think noone uses shared gcc libs in mingw, so we better do the same.
                # In any case, mingw32 g++ linking is broken by default with shared libs,
                # unless adding "-lsupc++" to any linking command. I don't know why.
                "--disable-shared"
                # To keep ABI compatibility with upstream mingw-w64
                "--enable-fully-dynamic-string"
              ] else ([
                "--enable-threads=posix"
                "--enable-nls"
                "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
              ] ++ (
                # In uclibc cases, libgomp needs an additional '-ldl'
                # and as I don't know how to pass it, I disable libgomp.
                optional (cross.libc == "uclibc") "--disable-libgomp"
              ))
            )
          );
    stageNameAddon = if crossStageStatic then "-stage-static" else "-stage-final";
    crossNameAddon = if cross != null then "-${cross.config}" + stageNameAddon else "";

  bootstrap = cross == null;

in

# We need all these X libraries when building AWT with GTK+.
assert x11Support -> (filter (x: x == null) ([ gtk libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  name = "${name}${if stripped then "" else "-debug"}-${version}" + crossNameAddon;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "1ny4smkp5bzs3cp8ss7pl6lk8yss0d9m4av1mvdp72r1x695akxq";
  };

  inherit patches;

  outputs = [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  postPatch =
    if (stdenv.isGNU
        || (libcCross != null                  # e.g., building `gcc.crossDrv'
            && libcCross ? crossConfig
            && libcCross.crossConfig == "i586-pc-gnu")
        || (crossGNU && libcCross != null))
    then
      # On GNU/Hurd glibc refers to Hurd & Mach headers and libpthread is not
      # in glibc, so add the right `-I' flags to the default spec string.
      assert libcCross != null -> libpthreadCross != null;
      let
        libc = if libcCross != null then libcCross else stdenv.glibc;
        gnu_h = "gcc/config/gnu.h";
        extraCPPDeps =
             libc.propagatedBuildInputs
          ++ stdenv.lib.optional (libpthreadCross != null) libpthreadCross
          ++ stdenv.lib.optional (libpthread != null) libpthread;
        extraCPPSpec =
          concatStrings (intersperse " "
                          (map (x: "-I${x.dev or x}/include") extraCPPDeps));
        extraLibSpec =
          if libpthreadCross != null
          then "-L${libpthreadCross}/lib ${libpthreadCross.TARGET_LDFLAGS}"
          else "-L${libpthread}/lib";
      in
        '' echo "augmenting \`CPP_SPEC' in \`${gnu_h}' with \`${extraCPPSpec}'..."
           sed -i "${gnu_h}" \
               -es'|CPP_SPEC *"\(.*\)$|CPP_SPEC "${extraCPPSpec} \1|g'

           echo "augmenting \`LIB_SPEC' in \`${gnu_h}' with \`${extraLibSpec}'..."
           sed -i "${gnu_h}" \
               -es'|LIB_SPEC *"\(.*\)$|LIB_SPEC "${extraLibSpec} \1|g'

           echo "setting \`NATIVE_SYSTEM_HEADER_DIR' and \`STANDARD_INCLUDE_DIR' to \`${libc}/include'..."
           sed -i "${gnu_h}" \
               -es'|#define STANDARD_INCLUDE_DIR.*$|#define STANDARD_INCLUDE_DIR "${libc}/include"|g'
        ''
    else if cross != null || stdenv.cc.libc != null then
      # On NixOS, use the right path to the dynamic linker instead of
      # `/lib/ld*.so'.
      let
        libc = if libcCross != null then libcCross else stdenv.cc.libc;
      in
        '' echo "fixing the \`GLIBC_DYNAMIC_LINKER' and \`UCLIBC_DYNAMIC_LINKER' macros..."
           for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
           do
             grep -q LIBC_DYNAMIC_LINKER "$header" || continue
             echo "  fixing \`$header'..."
             sed -i "$header" \
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc}\3"|g'
           done
        ''
    else null;

  inherit noSysDirs staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkgconfig);

  buildInputs = [ gmp mpfr libmpc libelf ]
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk libart_lgpl ] ++ xlibs))
    ++ (optionals (cross != null) [binutilsCross])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])

    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional stdenv.isDarwin gnused)
    ++ (optional stdenv.isDarwin binutils)
    ;

  NIX_LDFLAGS = stdenv.lib.optionalString  stdenv.isSunOS "-lm -ldl";

  preConfigure = stdenv.lib.optionalString (stdenv.isSunOS && stdenv.is64bit) ''
    export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
    export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
    export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
    export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    if SDKROOT=$(/usr/bin/xcrun --show-sdk-path); then
      configureFlagsArray+=(--with-native-system-header-dir=$SDKROOT/usr/include)
      makeFlagsArray+=( \
       CFLAGS_FOR_BUILD=-F$SDKROOT/System/Library/Frameworks \
       CFLAGS_FOR_TARGET=-F$SDKROOT/System/Library/Frameworks \
       FLAGS_FOR_TARGET=-F$SDKROOT/System/Library/Frameworks \
      )
    fi
  '';

  dontDisableStatic = true;

  configureFlags = [
    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-mpc=${libmpc}"
    "--disable-libstdcxx-pch"
    "--without-included-gettext"
    "--with-system-zlib"
    "--enable-static"
    "--enable-lto"
    (stdenv.lib.enableFeature enablePlugin "plugin")
    "--enable-languages=${builtins.concatStringsSep "," ([]
        ++ optional langC        "c"
        ++ optional langCC       "c++"
        ++ optional langFortran  "fortran"
        ++ optional langJava     "java"
        ++ optional langAda      "ada"
        ++ optional langVhdl     "vhdl"
        ++ optional langGo       "go"
        ++ optional langObjC     "objc"
        ++ optional langObjCpp   "obj-c++"
        ++ optionals crossDarwin [ "objc" "obj-c++" ]
    )}"
  ] ++ optional (!enableShared) "--disable-shared"
    ++ optional (isl != null) "--with-isl=${isl}"
    ++ optional (langJava && javaAntlr != null) "--with-antlr-jar=${javaAntlr}"
    ++ optional (libelf != null) "--with-libelf=${libelf}"
    ++ optional (stdenv ? glibc && cross == null) "--with-native-system-header-dir=${stdenv.glibc.dev}/include"
    ++ optional langAda "--enable-libada"
    ++ optional (cross == null && stdenv.isi686) "--with-arch=i686"
    ++ optional (!bootstrap) "--disable-bootstrap"
    ++ optional javaAwtGtk "--enable-java-awt=gtk"
    ++ (optionals (cross != null) crossConfigureFlags)
    ++ (optionals (cross == null) platformFlags)
    ++ (if enableMultilib
    then [ "--enable-multilib" "--disable-libquadmath" ]
    else [ "--disable-multilib" ]
  ) ++ (optionals langJava [
      "--with-ecj-jar=${javaEcj}"
      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home"
      "--with-java-home=\${prefix}/lib/jvm/jre"
  ]) ++ (optionals stdenv.isSunOS [
      "--enable-long-long"
      "--enable-libssp"
      "--enable-threads=posix"
      "--disable-nls"
      "--enable-__cxa_atexit"
      # On Illumos/Solaris GNU as is preferred
      "--with-gnu-as"
      "--without-gnu-ld"
  ]);

  targetConfig = if cross != null then cross.config else null;

  buildFlags = if bootstrap then
    (if profiledCompiler then "profiledbootstrap" else "bootstrap")
    else "";

  installTargets =
    if stripped
    then "install-strip"
    else "install";

  crossAttrs = let
    xgccArch = stdenv.cross.gcc.arch or null;
    xgccCpu = stdenv.cross.gcc.cpu or null;
    xgccAbi = stdenv.cross.gcc.abi or null;
    xgccFpu = stdenv.cross.gcc.fpu or null;
    xgccFloat = stdenv.cross.gcc.float or null;
  in {
    AR = "${stdenv.cross.config}-ar";
    LD = "${stdenv.cross.config}-ld";
    CC = "${stdenv.cross.config}-gcc";
    CXX = "${stdenv.cross.config}-gcc";
    AR_FOR_TARGET = "${stdenv.cross.config}-ar";
    LD_FOR_TARGET = "${stdenv.cross.config}-ld";
    CC_FOR_TARGET = "${stdenv.cross.config}-gcc";
    NM_FOR_TARGET = "${stdenv.cross.config}-nm";
    CXX_FOR_TARGET = "${stdenv.cross.config}-g++";
    # If we are making a cross compiler, cross != null
    NIX_CC_CROSS = if cross == null then "${stdenv.ccCross}" else "";
    dontStrip = true;
    configureFlags = [
      "--with-gmp=${gmp.crossDrv}"
      "--with-mpfr=${mpfr.crossDrv}"
      "--disable-libstdcxx-pch"
      "--without-included-gettext"
      "--with-system-zlib"
      "--target=${stdenv.cross.config}"
      "--enable-languages=${concatStringsSep "," (
             optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langJava     "java"
          ++ optional langAda      "ada"
          ++ optional langVhdl     "vhdl"
          ++ optional langGo       "go"
          )
        }"
    ] ++ optional (xgccArch != null) "--with-arch=${xgccArch}"
      ++ optional (xgccCpu != null) "--with-cpu=${xgccCpu}"
      ++ optional (xgccAbi != null) "--with-abi=${xgccAbi}"
      ++ optional (xgccFpu != null) "--with-fpu=${xgccFpu}"
      ++ optional (xgccFloat != null) "--with-float=${xgccFloat}"
      ++ optional (!enableMultilib) "--disable-multilib"
      ++ optional (!enableShared) "--disable-shared"
      ++ optional langJava "--with-ecj-jar=${javaEcj.crossDrv}"
      ++ optional javaAwtGtk "--enable-java-awt=gtk"
      ++ optional (langJava && javaAntlr != null) "--with-antlr-jar=${javaAntlr.crossDrv}"
      ++ optional (langAda) "--enable-libada"
    ;
    buildFlags = "";
  };


  # Needed for the cross compilation to work
  AR = "ar";
  LD = "ld";
  # http://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  CC = if stdenv.system == "x86_64-solaris" then "gcc -m64" else "gcc";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find
  # the library headers and binaries, regarless of the language being
  # compiled.

  # Note: When building the Java AWT GTK+ peer, the build system doesn't
  # honor `--with-gmp' et al., e.g., when building
  # `libjava/classpath/native/jni/java-math/gnu_java_math_GMP.c', so we just
  # add them to $CPATH and $LIBRARY_PATH in this case.
  #
  # Likewise, the LTO code doesn't find zlib.

  CPATH = concatStrings
            (intersperse ":" (map (x: "${x.dev or x}/include")
                                  (optionals (zlib != null) [ zlib ]
                                   ++ optionals langJava [ boehmgc ]
                                   ++ optionals javaAwtGtk xlibs
                                   ++ optionals javaAwtGtk [ gmp mpfr ]
                                   ++ optional (libpthread != null) libpthread
                                   ++ optional (libpthreadCross != null) libpthreadCross

                                   # On GNU/Hurd glibc refers to Mach & Hurd
                                   # headers.
                                   ++ optionals (libcCross != null && libcCross ? "propagatedBuildInputs" )
                                        libcCross.propagatedBuildInputs)));

  LIBRARY_PATH = concatStrings
                   (intersperse ":" (map (x: x + "/lib")
                                         (optionals (zlib != null) [ zlib ]
                                          ++ optionals langJava [ boehmgc ]
                                          ++ optionals javaAwtGtk xlibs
                                          ++ optionals javaAwtGtk [ gmp mpfr ]
                                          ++ optional (libpthread != null) libpthread)));

  EXTRA_TARGET_CFLAGS =
    if cross != null && libcCross != null
    then "-idirafter ${libcCross}/include"
    else null;

  EXTRA_TARGET_LDFLAGS =
    if cross != null && libcCross != null
    then "-B${libcCross}/lib -Wl,-L${libcCross}/lib" +
         (optionalString (libpthreadCross != null)
           " -L${libpthreadCross}/lib -Wl,${libpthreadCross.TARGET_LDFLAGS}")
    else null;

  passthru =
    { inherit langC langCC langObjC langObjCpp langAda langFortran langVhdl langGo version; isGNU = true; };

  inherit enableParallelBuilding enableMultilib;

  inherit (stdenv) is64bit;

  meta = {
    homepage = http://gcc.gnu.org/;
    license = stdenv.lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}"
      + (if stripped then "" else " (with debugging info)");

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, Java, and Ada, as well
      as libraries for these languages (libstdc++, libgcj, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = with stdenv.lib.maintainers; [ viric peti ];

    # gnatboot is not available out of linux platforms, so we disable the darwin build
    # for the gnat (ada compiler).
    platforms =
      stdenv.lib.platforms.linux ++
      stdenv.lib.platforms.freebsd ++
      optionals (langAda == false) stdenv.lib.platforms.darwin;
  };
}

// optionalAttrs (cross != null && cross.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

# Strip kills static libs of other archs (hence cross != null)
// optionalAttrs (!stripped || cross != null) { dontStrip = true; NIX_STRIP_DEBUG = 0; }

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
)
