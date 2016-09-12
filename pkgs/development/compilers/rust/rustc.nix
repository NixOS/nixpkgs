{ stdenv, fetchurl, fetchgit, fetchzip, file, python2, tzdata, procps
, llvm, jemalloc, ncurses, darwin, binutils, rustPlatform, git, cmake, curl

, isRelease ? false
, shortVersion
, forceBundledLLVM ? false
, srcSha, srcRev
, configureFlags ? []
, patches
, targets
, targetPatches
, targetToolchains
} @ args:

let
  inherit (stdenv.lib) optional optionalString;

  version = if isRelease then
      "${shortVersion}"
    else
      "${shortVersion}-g${builtins.substring 0 7 srcRev}";

  name = "rustc-${version}";

  procps = if stdenv.isDarwin then darwin.ps else args.procps;

  llvmShared = llvm.override { enableSharedLibraries = true; };

  target = builtins.replaceStrings [" "] [","] (builtins.toString targets);

  meta = with stdenv.lib; {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan wizeman globin havvy wkennington retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
in

stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  __impureHostDeps = [ "/usr/lib/libedit.3.dylib" ];

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-rpath ${llvmShared}/lib";

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = srcRev;
    sha256 = srcSha;
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  configureFlags = configureFlags
                ++ [ "--enable-local-rust" "--local-rust-root=${rustPlatform.rust.rustc}" "--enable-rpath" ]
                # ++ [ "--jemalloc-root=${jemalloc}/lib"
                ++ [ "--default-linker=${stdenv.cc}/bin/cc" "--default-ar=${binutils.out}/bin/ar" ]
                ++ optional (stdenv.cc.cc ? isClang) "--enable-clang"
                ++ optional (targets != []) "--target=${target}"
                ++ optional (!forceBundledLLVM) "--llvm-root=${llvmShared}";

  patches = patches ++ targetPatches;

  passthru.target = target;

  postPatch = ''
    substituteInPlace src/rust-installer/gen-install-script.sh \
      --replace /bin/echo "$(type -P echo)"
    substituteInPlace src/rust-installer/gen-installer.sh \
      --replace /bin/echo "$(type -P echo)"

    # Workaround for NixOS/nixpkgs#8676
    substituteInPlace mk/rustllvm.mk \
      --replace "\$\$(subst  /,//," "\$\$(subst /,/,"

    # Fix dynamic linking against llvm
    ${optionalString (!forceBundledLLVM) ''sed -i 's/, kind = \\"static\\"//g' src/etc/mklldeps.py''}

    # Fix the configure script to not require curl as we won't use it
    sed -i configure \
      -e '/probe_need CFG_CURL curl/d'

    # Fix the use of jemalloc prefixes which our jemalloc doesn't have
    # TODO: reenable if we can figure out how to get our jemalloc to work
    #[ -f src/liballoc_jemalloc/lib.rs ] && sed -i 's,je_,,g' src/liballoc_jemalloc/lib.rs
    #[ -f src/liballoc/heap.rs ] && sed -i 's,je_,,g' src/liballoc/heap.rs # Remove for 1.4.0+

    # Disable fragile linker-output-non-utf8 test
    rm -vr src/test/run-make/linker-output-non-utf8/

    # Useful debugging parameter
    # export VERBOSE=1
  '';

  preConfigure = ''
    # Needed flags as the upstream configure script has a broken prefix substitution
    configureFlagsArray+=("--datadir=$out/share")
    configureFlagsArray+=("--infodir=$out/share/info")
  '';

  # rustc unfortunately need cmake for compiling llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  # ps is needed for one of the test cases
  nativeBuildInputs = [ file python2 procps rustPlatform.rust.rustc git cmake ];

  buildInputs = [ ncurses ] ++ targetToolchains
    ++ optional (!forceBundledLLVM) llvmShared;

  # https://github.com/rust-lang/rust/issues/30181
  # enableParallelBuilding = false; # missing files during linking, occasionally

  outputs = [ "out" "doc" ];
  setOutputFlags = false;

  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
    ${optionalString stdenv.isDarwin "export TMPDIR=/tmp"}
  '';

  # Disable doCheck on Darwin to work around upstream issue
  doCheck = true;
  dontSetConfigureCross = true;
}
