{ stdenv, targetPackages, fetchurl, noSysDirs, fetchpatch
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langJava ? false
, langGo ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which
, libelf                      # optional, for link-time optimizations (LTO)
, cloog ? null, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, x11Support ? langJava
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, crossStageStatic ? false
, # Strip kills static libs of other archs (hence no cross)
  stripped ? stdenv.hostPlatform == stdenv.buildPlatform
          && stdenv.targetPlatform == stdenv.hostPlatform
, gnused ? null
, buildPackages
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'

# We enable the isl cloog backend.
assert cloog != null -> isl != null;

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert stdenv.hostPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

with stdenv.lib;
with builtins;

let version = "4.9.4";

    enableParallelBuilding = true;

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
      [ ../use-source-date-epoch.patch ]
      ++ optionals enableParallelBuilding [ ../parallel-bconfig.patch ./parallel-strsignal.patch ]
      ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      ++ optional langFortran ../gfortran-driving.patch
      ++ [ ../struct-ucontext.patch ../struct-sigaltstack-4.9.patch ] # glibc-2.26
      # Retpoline patches pulled from the branch hjl/indirect/gcc-4_9-branch (by H.J. Lu, the author of GCC upstream retpoline commits)
      ++ builtins.map ({commit, sha256}: fetchpatch {url = "https://github.com/hjl-tools/gcc/commit/${commit}.patch"; inherit sha256;})
         [{ commit = "e623d21608e96ecd6b65f0d06312117d20488a38"; sha256 = "1ix8i4d2r3ygbv7npmsdj790rhxqrnfwcqzv48b090r9c3ij8ay3"; }
          { commit = "2015a09e332309f12de1dadfe179afa6a29368b8"; sha256 = "0xcfs0cbb63llj2gbcdrvxim79ax4k4aswn0a3yjavxsj71s1n91"; }
          { commit = "6b11591f4494f705e8746e7d58b7f423191f4e92"; sha256 = "0aydyhsm2ig0khgbp27am7vq7liyqrq6kfhfi2ki0ij0ab1hfbga"; }
          { commit = "203c7d9c3e9cb0f88816b481ef8e7e87b3ecc373"; sha256 = "0wqn16y7wy5kg8ngfcni5qdwfphl01axczibbk49bxclwnzvldqa"; }
          { commit = "f039c6f284b2c9ce97c8353d6034978795c4872e"; sha256 = "13fkgdb17lpyxfksz1zanxhgpsm0jrss9w61nbl7an4im22hz7ci"; }
          { commit = "ed42606bdab1c5d9e5ad828cd6fe1a0557f193b7"; sha256 = "0gdnn8v3p03imj3qga2mzdhpgbmjcklkxdl97jvz5xia2ikzknxm"; }
          { commit = "5278e062ef292fd2fbf987d25389785f4c5c0f99"; sha256 = "0j81x758wf8v7j4rx5wc1cy7yhkvhlhv3wmnarwakxiwsspq0vrs"; }
          { commit = "76f1ffbbb6cd9f6ecde6c82cd16e20a27242e890"; sha256 = "1py56y6gp7fjf4f8bbsfwh5bs1gnmlqda1ycsmnwlzfm0cshdp0c"; }
          { commit = "4ca48b2b688b135c0390f54ea9077ef10aedd52c"; sha256 = "15r019pzr3k0lpgyvdc92c8fayw8b5lrzncna4bqmamcsdz7vsaw"; }
          { commit = "98c7bf9ddc80db965d69d61521b1c7a1cec32d9a"; sha256 = "1d7pfdv1q23nf0wadw7jbp6d6r7pnzjpbyxgbdfv7j1vr9l1bp60"; }
          { commit = "3dc76b53ad896494ca62550a7a752fecbca3f7a2"; sha256 = "0jvdzfpvfdmklfcjwqblwq1i22iqis7ljpvm7adra5d7zf2xk7xz"; }
          { commit = "1e961ed49b18e176c7457f53df2433421387c23b"; sha256 = "04dnqqs4qsvz4g8cq6db5id41kzys7hzhcaycwmc9rpqygs2ajwz"; }
          { commit = "e137c72d099f9b3b47f4cc718aa11eab14df1a9c"; sha256 = "1ms0dmz74yf6kwgjfs4d2fhj8y6mcp2n184r3jk44wx2xc24vgb2"; }];

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
      ] else if crossStageStatic then [
        "--disable-libssp"
        "--disable-nls"
        "--without-headers"
        "--disable-threads"
        "--disable-libgomp"
        "--disable-libquadmath"
        "--disable-shared"
        "--disable-libatomic"  # libatomic requires libc
        "--disable-decimal-float" # libdecnumber requires libc
      ] else [
        (if crossDarwin then "--with-sysroot=${getLib libcCross}/share/sysroot"
         else                "--with-headers=${getDev libcCross}/include")
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
          ] ++ [
          "--enable-threads=posix"
          "--enable-nls"
          "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
        ]));
    stageNameAddon = if crossStageStatic then "-stage-static" else "-stage-final";
    crossNameAddon = if targetPlatform != hostPlatform then "${targetPlatform.config}${stageNameAddon}-" else "";

    bootstrap = targetPlatform == hostPlatform;

in

# We need all these X libraries when building AWT with GTK+.
assert x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  name = crossNameAddon + "${name}${if stripped then "" else "-debug"}-${version}";

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "14l06m7nvcvb0igkbip58x59w3nq6315k6jcz3wr9ch1rn9d44bc";
  };

  inherit patches;

  hardeningDisable = [ "format" ];

  outputs = if langJava || langGo then ["out" "man" "info"]
    else [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  postPatch =
    if targetPlatform != hostPlatform || stdenv.cc.libc != null then
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
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g'
           done
        ''
    else null;

  # TODO(@Ericson2314): Make passthru instead. Weird to avoid mass rebuild,
  crossStageStatic = targetPlatform == hostPlatform || crossStageStatic;
  inherit noSysDirs staticCompiler langJava
    libcCross crossMingw;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkgconfig);

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
  ] ++ (optional (cloog != null) cloog)
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs))
    ++ (optionals (targetPlatform != hostPlatform) [targetPackages.stdenv.cc.bintools])

    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional hostPlatform.isDarwin gnused)
    ;

  preConfigure = stdenv.lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
    sed -i -e "s/-lrt//g" libstdc++-v3/configure
    export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
    export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
    export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
    export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
  ''
  + stdenv.lib.optionalString (langJava || langGo) ''
    export lib=$out;
  ''
  ;

  dontDisableStatic = true;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";

  configureFlags =
    # Basic dependencies
    [
      "--with-gmp-include=${gmp.dev}/include"
      "--with-gmp-lib=${gmp.out}/lib"
      "--with-mpfr=${mpfr.dev}"
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
          ++ optional langJava     "java"
          ++ optional langGo       "go"
          ++ optional langObjC     "objc"
          ++ optional langObjCpp   "obj-c++"
          ++ optionals crossDarwin [ "objc" "obj-c++" ]
          )
        )
      }"
    ] ++

    (if enableMultilib
      then ["--enable-multilib" "--disable-libquadmath"]
      else ["--disable-multilib"]) ++
    optional (!enableShared) "--disable-shared" ++
    (if enablePlugin
      then ["--enable-plugin"]
      else ["--disable-plugin"]) ++

    # Optional features
    optional (isl != null) "--with-isl=${isl}" ++
    optionals (cloog != null) [
      "--with-cloog=${cloog}"
      "--disable-cloog-version-check"
      "--enable-cloog-backend=isl"
    ] ++

    # Java options
    optionals langJava [
      "--with-ecj-jar=${javaEcj}"

      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home"
      "--with-java-home=\${prefix}/lib/jvm/jre"
    ] ++
    optional javaAwtGtk "--enable-java-awt=gtk" ++
    optional (langJava && javaAntlr != null) "--with-antlr-jar=${javaAntlr}" ++

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
  ;

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (bootstrap && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  dontStrip = !stripped;

  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv

  installTargets =
    if stripped
    then "install-strip"
    else "install";

  # http://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Note: When building the Java AWT GTK+ peer, the build system doesn't honor
  # `--with-gmp' et al., e.g., when building
  # `libjava/classpath/native/jni/java-math/gnu_java_math_GMP.c', so we just add
  # them to $CPATH and $LIBRARY_PATH in this case.
  #
  # Likewise, the LTO code doesn't find zlib.
  #
  # Cross-compiling, we need gcc not to read ./specs in order to build the g++
  # compiler (after the specs for the cross-gcc are created). Having
  # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

  CPATH = optionals (targetPlatform == hostPlatform) (makeSearchPathOutput "dev" "include" ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
  ));

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]));

  EXTRA_TARGET_FLAGS = optionals
    (targetPlatform != hostPlatform && libcCross != null)
    ([
      "-idirafter ${getDev libcCross}/include"
    ] ++ optionals (! crossStageStatic) [
      "-B${libcCross.out}/lib"
    ]);

  EXTRA_TARGET_LDFLAGS = optionals
    (targetPlatform != hostPlatform && libcCross != null)
    ([
      "-Wl,-L${libcCross.out}/lib"
    ] ++ (if crossStageStatic then [
        "-B${libcCross.out}/lib"
      ] else [
        "-Wl,-rpath,${libcCross.out}/lib"
        "-Wl,-rpath-link,${libcCross.out}/lib"
    ]));

  passthru =
    { inherit langC langCC langObjC langObjCpp langFortran langGo version; isGNU = true; };

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

    maintainers = with stdenv.lib.maintainers; [ peti ];

    platforms =
      stdenv.lib.platforms.linux ++
      stdenv.lib.platforms.freebsd ++
      stdenv.lib.platforms.illumos;
  };
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }

// optionalAttrs (langJava) {
     postFixup = ''
       target="$(echo "$out/libexec/gcc"/*/*/ecj*)"
       patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
     '';}
)
