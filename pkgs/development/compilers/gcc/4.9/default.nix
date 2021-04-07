{ lib, stdenv, targetPackages, fetchurl, fetchpatch, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langJava ? false
, langGo ? false
, profiledCompiler ? false
, langJit ? false
, staticCompiler ? false
, # N.B. the defult is intentionally not from an `isStatic`. See
  # https://gcc.gnu.org/install/configure.html - this is about target
  # platform libraries not host platform ones unlike normal. But since
  # we can't rebuild those without also rebuilding the compiler itself,
  # we opt to always build everything unlike our usual policy.
  enableShared ? true
, enableLTO ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which, patchelf
, libelf                      # optional, for link-time optimizations (LTO)
, cloog ? null, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkg-config ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xorgproto ? null
, libXrandr ? null, libXi ? null
, x11Support ? langJava
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, threadsCross ? null # for MinGW
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

# threadsCross is just for MinGW
assert threadsCross != null -> stdenv.targetPlatform.isWindows;

with lib;
with builtins;

let majorVersion = "4";
    version = "${majorVersion}.9.4";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
      [ ../use-source-date-epoch.patch ../parallel-bconfig.patch ./parallel-strsignal.patch
        ./libsanitizer.patch
        (fetchpatch {
          name = "avoid-ustat-glibc-2.28.patch";
          url = "https://gitweb.gentoo.org/proj/gcc-patches.git/plain/4.9.4/gentoo/100_all_avoid-ustat-glibc-2.28.patch?id=55fcb515620a8f7d3bb77eba938aa0fcf0d67c96";
          sha256 = "0b32sb4psv5lq0ij9fwhi1b4pjbwdjnv24nqprsk14dsc6xmi1g0";
        })
      ]
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
      url = "https://www.antlr.org/download/antlr-4.4-complete.jar";
      sha256 = "02lda2imivsvsis8rnzmbrbp8rh1kb8vmq4i67pqhkwz7lf8y6dz";
    };

    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xorgproto
    ];

    javaAwtGtk = langJava && x11Support;

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    stageNameAddon = if crossStageStatic then "stage-static" else "stage-final";
    crossNameAddon = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-${stageNameAddon}-";

in

# We need all these X libraries when building AWT with GTK.
assert x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  pname = "${crossNameAddon}${name}${if stripped then "" else "-debug"}";
  inherit version;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "14l06m7nvcvb0igkbip58x59w3nq6315k6jcz3wr9ch1rn9d44bc";
  };

  inherit patches;

  hardeningDisable = [ "format" "pie" ];

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

  inherit noSysDirs staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkg-config);

  # For building runtime libs
  depsBuildTarget =
    (
      if hostPlatform == buildPlatform then [
        targetPackages.stdenv.cc.bintools # newly-built gcc will be used
      ] else assert targetPlatform == hostPlatform; [ # build != host == target
        stdenv.cc
      ]
    )
    ++ optional targetPlatform.isLinux patchelf;

  buildInputs = [
    gmp mpfr libmpc libelf
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ] ++ (optional (cloog != null) cloog)
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs))
    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional hostPlatform.isDarwin gnused)
    ;

  depsTargetTarget = optional (!crossStageStatic && threadsCross != null) threadsCross;

  preConfigure = import ../common/pre-configure.nix {
    inherit lib;
    inherit version hostPlatform langJava langGo;
  };

  dontDisableStatic = true;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ lib.optional (targetPlatform != hostPlatform) "target";

  configureFlags = import ../common/configure-flags.nix {
    inherit
      lib
      stdenv
      targetPackages
      crossStageStatic libcCross
      version

      gmp mpfr libmpc libelf isl
      cloog

      enableLTO
      enableMultilib
      enablePlugin
      enableShared

      langC
      langCC
      langFortran
      langJava javaAwtGtk javaAntlr javaEcj
      langGo
      langObjC
      langObjCpp
      langJit
      ;
  };

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (targetPlatform == hostPlatform && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  dontStrip = !stripped;

  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv

  installTargets = optional stripped "install-strip";

  # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Note: When building the Java AWT GTK peer, the build system doesn't honor
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
    ++ optionals javaAwtGtk [ gmp mpfr ]
  ));

  inherit
    (import ../common/extra-target-flags.nix {
      inherit lib stdenv crossStageStatic libcCross threadsCross;
    })
    EXTRA_FLAGS_FOR_TARGET
    EXTRA_LDFLAGS_FOR_TARGET
    ;

  passthru = {
    inherit langC langCC langObjC langObjCpp langFortran langGo version;
    isGNU = true;
  };

  enableParallelBuilding = true;
  inherit enableMultilib;

  inherit (stdenv) is64bit;

  meta = {
    homepage = "https://gcc.gnu.org/";
    license = lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}"
      + (if stripped then "" else " (with debugging info)");

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, Java, and Ada, as well
      as libraries for these languages (libstdc++, libgcj, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = with lib.maintainers; [ peti veprbl ];

    platforms =
      lib.platforms.linux ++
      lib.platforms.freebsd ++
      lib.platforms.illumos ++
      lib.platforms.darwin;
    badPlatforms = [ "x86_64-darwin" ];
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
