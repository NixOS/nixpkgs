{ stdenv, targetPackages
, buildPlatform, hostPlatform, targetPlatform

# build-tools
, bootPkgs, alex, happy, hscolour
, autoconf, autoreconfHook, automake, coreutils, fetchurl, fetchpatch, perl, python3, sphinx
, runCommand

, libiconv ? null, ncurses

, useLLVM ? !targetPlatform.isx86 || (targetPlatform.isMusl && hostPlatform != targetPlatform)
, # LLVM is conceptually a run-time-only depedendency, but for
  # non-x86, we need LLVM to bootstrap later stages, so it becomes a
  # build-time dependency too.
  buildLlvmPackages, llvmPackages

, # If enabled, GHC will be built with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
  enableIntegerSimple ? !(gmp.meta.available or false), gmp

, # If enabled, use -fPIC when compiling static libs.
  enableRelocatedStaticLibs ? targetPlatform != hostPlatform

, # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? true

, # What flavour to build. An empty string indicates no
  # specific flavour and falls back to ghc default values.
  ghcFlavour ? stdenv.lib.optionalString (targetPlatform != hostPlatform) "perf-cross"
, # Whether to backport https://phabricator.haskell.org/D4388 for
  # deterministic profiling symbol names, at the cost of a slightly
  # non-standard GHC API
  deterministicProfiling ? false
}:

assert !enableIntegerSimple -> gmp != null;

let
  inherit (bootPkgs) ghc;

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = stdenv.lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";

  buildMK = ''
    BuildFlavour = ${ghcFlavour}
    ifneq \"\$(BuildFlavour)\" \"\"
    include mk/flavours/\$(BuildFlavour).mk
    endif
    DYNAMIC_GHC_PROGRAMS = ${if enableShared then "YES" else "NO"}
    INTEGER_LIBRARY = ${if enableIntegerSimple then "integer-simple" else "integer-gmp"}
  '' + stdenv.lib.optionalString (targetPlatform != hostPlatform) ''
    Stage1Only = ${if targetPlatform.system == hostPlatform.system then "NO" else "YES"}
    CrossCompilePrefix = ${targetPrefix}
    HADDOCK_DOCS = NO
    BUILD_SPHINX_HTML = NO
    BUILD_SPHINX_PDF = NO
  '' + stdenv.lib.optionalString enableRelocatedStaticLibs ''
    GhcLibHcOpts += -fPIC
    GhcRtsHcOpts += -fPIC
  '' + stdenv.lib.optionalString targetPlatform.useAndroidPrebuilt ''
    EXTRA_CC_OPTS += -std=gnu99
  '';

  # Splicer will pull out correct variations
  libDeps = platform: [ ncurses ]
    ++ stdenv.lib.optional (!enableIntegerSimple) gmp
    ++ stdenv.lib.optional (platform.libc != "glibc") libiconv;

  toolsForTarget =
    if hostPlatform == buildPlatform then
      [ targetPackages.stdenv.cc ] ++ stdenv.lib.optional useLLVM llvmPackages.llvm
    else assert targetPlatform == hostPlatform; # build != host == target
      [ stdenv.cc ] ++ stdenv.lib.optional useLLVM buildLlvmPackages.llvm;

  targetCC = builtins.head toolsForTarget;

in
stdenv.mkDerivation rec {
  version = "8.2.2";
  name = "${targetPrefix}ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/${version}/ghc-${version}-src.tar.xz";
    sha256 = "1z05vkpaj54xdypmaml50hgsdpw29dhbs2r7magx0cm199iw73mv";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  patches = [
    (fetchpatch { # Fix STRIP to be substituted from configure
      url = "https://git.haskell.org/ghc.git/commitdiff_plain/2fc8ce5f0c8c81771c26266ac0b150ca9b75c5f3";
      sha256 = "03253ci40np1v6k0wmi4aypj3nmj3rdyvb1k6rwqipb30nfc719f";
    })
    (import ./abi-depends-determinism.nix { inherit fetchpatch runCommand; })
  ] ++ stdenv.lib.optionals (hostPlatform != targetPlatform && targetPlatform.system == hostPlatform.system) [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/08a41d2dff99645af6ac5a7bb4774f5f193b6f20/dev-lang/ghc/files/ghc-8.2.1_rc1-unphased-cross.patch";
      sha256 = "1hxj80bjx0x3w0f35cj3k2wipppr1ald03jwfy5q0xlxygdha17w";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/08a41d2dff99645af6ac5a7bb4774f5f193b6f20/dev-lang/ghc/files/ghc-8.2.1_rc1-staged-cross.patch";
      sha256 = "12xsln3zyfpvml8bwdpbc003h6zl1qh2qcq1rhdrw02n45dz8lvc";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/08a41d2dff99645af6ac5a7bb4774f5f193b6f20/dev-lang/ghc/files/ghc-8.2.1_rc1-ghci-cross.patch";
      sha256 = "03dcqf5af3vjhrky3f2z26j4d9h8qd9nkv76xp0l97h4cqk7vfqb";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/08a41d2dff99645af6ac5a7bb4774f5f193b6f20/dev-lang/ghc/files/ghc-8.2.1_rc1-stage2-cross.patch";
      sha256 = "0pi2m85wjxaaablq6n4q5vyn9qxvry5d7nmja4b28i68yb4ly9g1";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/08a41d2dff99645af6ac5a7bb4774f5f193b6f20/dev-lang/ghc/files/ghc-8.2.1_rc1-hp2ps-cross.patch";
      sha256 = "1fszfavf1cvrf02x500mi7jykcpvpl2i7i4qzr2qz9sbmyq063f0";
    })
  ] ++ stdenv.lib.optional deterministicProfiling
    (fetchpatch { # Backport of https://phabricator.haskell.org/D4388 for more determinism
      url = "https://github.com/shlevy/ghc/commit/fec1b8d3555c447c0d8da0e96b659be67c8bb4bc.patch";
      sha256 = "1lyysz6hfd1njcigpm8xppbnkadqfs0kvrp7s8vqgb38pjswj5hg";
    })
    ++ stdenv.lib.optional stdenv.isDarwin ./backport-dylib-command-size-limit.patch;

  postPatch = "patchShebangs .";

  # GHC is a bit confused on its cross terminology.
  preConfigure = ''
    for env in $(env | grep '^TARGET_' | sed -E 's|\+?=.*||'); do
      export "''${env#TARGET_}=''${!env}"
    done
    # GHC is a bit confused on its cross terminology, as these would normally be
    # the *host* tools.
    export CC="${targetCC}/bin/${targetCC.targetPrefix}cc"
    export CXX="${targetCC}/bin/${targetCC.targetPrefix}cxx"
    # Use gold to work around https://sourceware.org/bugzilla/show_bug.cgi?id=16177
    export LD="${targetCC.bintools}/bin/${targetCC.bintools.targetPrefix}ld${stdenv.lib.optionalString targetPlatform.isAarch32 ".gold"}"
    export AS="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}as"
    export AR="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}ar"
    export NM="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}nm"
    export RANLIB="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}ranlib"
    export READELF="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}readelf"
    export STRIP="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}strip"

    echo -n "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ]
    ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";
  # `--with` flags for libraries needed for RTS linker
  configureFlags = [
    "--datadir=$doc/share/doc/ghc"
  ] ++ stdenv.lib.optional (targetPlatform == hostPlatform) [
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
  ] ++ stdenv.lib.optional (targetPlatform == hostPlatform && !enableIntegerSimple) [
    "--with-gmp-includes=${targetPackages.gmp.dev}/include" "--with-gmp-libraries=${targetPackages.gmp.out}/lib"
  ] ++ stdenv.lib.optional (targetPlatform == hostPlatform && hostPlatform.libc != "glibc") [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ] ++ stdenv.lib.optionals (targetPlatform != hostPlatform) [
    "--enable-bootstrap-with-devel-snapshot"
  ] ++ stdenv.lib.optionals (targetPlatform.isAarch32) [
    "CFLAGS=-fuse-ld=gold"
    "CONF_GCC_LINKER_OPTS_STAGE1=-fuse-ld=gold"
    "CONF_GCC_LINKER_OPTS_STAGE2=-fuse-ld=gold"
  ] ++ stdenv.lib.optionals (targetPlatform.isDarwin && targetPlatform.isAarch64) [
    # fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
    "--disable-large-address-space"
  ];

  # Make sure we never relax`$PATH` and hooks support for compatability.
  strictDeps = true;

  nativeBuildInputs = [
    autoconf autoreconfHook automake perl python3 sphinx
    ghc alex happy hscolour
  ];

  # For building runtime libs
  depsBuildTarget = toolsForTarget;

  buildInputs = libDeps hostPlatform;

  propagatedBuildInputs = [ targetPackages.stdenv.cc ]
    ++ stdenv.lib.optional useLLVM llvmPackages.llvm;

  depsTargetTarget = map stdenv.lib.getDev (libDeps targetPlatform);
  depsTargetTargetPropagated = map (stdenv.lib.getOutput "out") (libDeps targetPlatform);

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!targetPlatform.isDarwin) "--keep-file-symbols";

  checkTarget = "test";
  doCheck = false; # fails with "testsuite/tests: No such file or directory.  Stop."

  hardeningDisable = [ "format" ];

  postInstall = ''
    for bin in "$out"/lib/${name}/bin/*; do
      isELF "$bin" || continue
      paxmark m "$bin"
    done

    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc

    # Patch scripts to include "readelf" and "cat" in $PATH.
    for i in "$out/bin/"*; do
      test ! -h $i || continue
      egrep --quiet '^#!' <(head -n 1 $i) || continue
      sed -i -e '2i export PATH="$PATH:${stdenv.lib.makeBinPath [ targetPackages.stdenv.cc.bintools coreutils ]}"' $i
    done
  '';

  passthru = {
    inherit bootPkgs targetPrefix;

    inherit llvmPackages;
    inherit enableShared;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-8.2.2";
  };

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
