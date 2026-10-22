{
  version,
  hash,
  patches ? [ ],
}:

{
  lib,
  stdenv,
  fetchurl,
  which,
  python3,
  gfortran,
  cacert,
  cmake,
  perl,
  gnum4,
  openssl,
  libgit2,
  libssh2,
  libxml2,
  nghttp2,
  zlib,
  zstd,
  buildPackages,
  darwin,
  unzip,
  ncurses,
  curl,
}:

let
  # Julia >= 1.12 swapped its vendored TLS stack from mbedtls to OpenSSL and
  # supports the USE_SYSTEM_* build flags to link against system libraries.
  # Sonames checked against Julia's stdlib JLL stubs (stdlib/*_jll):
  #   libssl.so.3, libcrypto.so.3, libcurl.so.4, libgit2.so.1.9,
  #   libssh2.so.1, libnghttp2.so.14, libz.so.1, libzstd.so.1
  # WARNING: libgit2 uses MAJOR.MINOR for its soname (libgit2.so.1.9); bumping
  # nixpkgs libgit2 past 1.9 will break LibGit2_jll unless a compatibility
  # symlink is provided or LibGit2_jll is patched.
  useSystemNetworkStack = lib.versionAtLeast version "1.12";

  networkStackLibs = [
    openssl
    curl
    libgit2
    libssh2
    nghttp2
    zlib
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.13") [
    zstd
  ];

  skip_tests = [
    # test flaky on ofborg
    "channels"
    # test flaky
    "read"
    "NetworkOptions"
    "REPL"
    "ccall"
  ]
  ++ lib.optionals (lib.versions.majorMinor version == "1.10") [
    "LinearAlgebra/blas"
    "ambiguous"
    "compiler/contextual"
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.10") [
    # Loading tests try to download package registries in the sandbox.
    "loading"
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.11") [
    "cmdlineargs"
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.12") [
    "Distributed"
    # test flaky because of our RPATH patching
    # https://github.com/NixOS/nixpkgs/pull/230965#issuecomment-1545336489
    "Compiler/codegen"
    "precompile"
    "compileall"
  ]
  ++ lib.optionals (lib.versionOlder version "1.12") [
    "compiler/codegen" # older versions' test was in lowercase
  ]
  ++ lib.optionals useSystemNetworkStack [
    # Upstream stdlib JLL stub tests assert exact equality with BinaryBuilder's
    # pinned versions (e.g. OpenSSL 3.5.8, Zstd 1.5.7). When devendored, system
    # versions differ. Functional testing is covered by the stdlib suites
    # (LibGit2, download, Tar, Sockets, etc.) and postInstallCheck smoke tests.
    "OpenSSL_jll"
    "LibGit2_jll"
    "LibSSH2_jll"
    "nghttp2_jll"
    "Zlib_jll"
  ]
  ++ lib.optionals (useSystemNetworkStack && lib.versionAtLeast version "1.13") [
    "Zstd_jll"
  ];
in

stdenv.mkDerivation rec {
  pname = "julia";

  inherit version patches;

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    inherit hash;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    which
    python3
    gfortran
    cmake
    perl
    gnum4
    openssl
  ]
  ++ lib.optionals (useSystemNetworkStack && lib.versionAtLeast version "1.13") [
    # base/Makefile symlinks the zstd CLI into libexec/julia for Pkg to use
    zstd.bin
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    darwin.DarwinTools
    darwin.sigtool
    darwin.autoSignDarwinBinariesHook
    unzip
  ];

  buildInputs = [
    libxml2
    zlib
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.11") [
    cacert
  ]
  ++ lib.optionals useSystemNetworkStack [
    openssl
    curl
    libgit2
    libssh2
    nghttp2
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.13") [
    zstd
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  ''
  + lib.optionalString (lib.versionAtLeast version "1.11") ''
    substituteInPlace deps/curl.mk \
      --replace-fail 'jxf $(notdir $<)' \
                     'jxf $(notdir $<) && sed -i "s|/usr/bin/env perl|${lib.getExe buildPackages.perl}|" curl-$(CURL_VER)/scripts/cd2nroff'
  ''
  + lib.optionalString (lib.versionOlder version "1.12") ''
    substituteInPlace deps/tools/common.mk \
      --replace-fail "CMAKE_COMMON := " "CMAKE_COMMON := ${lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10"} "
  '';

  preBuild =
    lib.optionalString (lib.versionAtLeast version "1.11") ''
      # terminfo dirs normally inaccessible in build sandbox
      export TERMINFO="${ncurses.out}/share/terminfo/";
    ''
    + lib.optionalString useSystemNetworkStack ''
      # With USE_SYSTEM_LIBGIT2=1, Julia's rule that stages the Mozilla CA
      # bundle (share/julia/cert.pem, used by NetworkOptions.bundled_ca_roots)
      # never runs, so provide our own up-to-date copy.
      mkdir -p usr/share/julia
      cp ${cacert}/etc/ssl/certs/ca-bundle.crt usr/share/julia/cert.pem
    '';

  env =
    (lib.optionalAttrs (lib.versionOlder version "1.11" || stdenv.hostPlatform.isAarch64) {
      NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=implicit-function-declaration"
        "-Wno-error=incompatible-pointer-types"
      ];
    })
    // (lib.optionalAttrs useSystemNetworkStack {
      # `base/Makefile` locates the system libraries with Julia's `libwhich`
      # helper, which resolves them with a bare dlopen. libwhich only reads
      # LIBWHICH_LIBRARY_PATH, and then re-executes itself with the value in
      # LD_LIBRARY_PATH or DYLD_LIBRARY_PATH, so set both.
      LIBWHICH_LIBRARY_PATH = lib.makeLibraryPath networkStackLibs;
      LD_LIBRARY_PATH = lib.makeLibraryPath networkStackLibs;
    });

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # https://github.com/JuliaCI/julia-buildkite/blob/main/utilities/build_envs.sh
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)"
    # OpenBLAS getarch CPU detection fails in Nix sandbox;
    # Using NEHALEM as a baseline
    "OPENBLAS_TARGET_ARCH=NEHALEM"
    "OPENBLAS_DYNAMIC_ARCH=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-512tvb,base(3)"
  ]
  ++ lib.optionals useSystemNetworkStack [
    "USE_SYSTEM_OPENSSL=1"
    "USE_SYSTEM_LIBSSH2=1"
    "USE_SYSTEM_NGHTTP2=1"
    "USE_SYSTEM_CURL=1"
    "USE_SYSTEM_LIBGIT2=1"
    "USE_SYSTEM_ZLIB=1"
  ]
  ++ lib.optionals (useSystemNetworkStack && lib.versionAtLeast version "1.13") [
    "USE_SYSTEM_ZSTD=1"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    for file in libcurl.so libgmpxx.so libmpfr.so; do
      if [ -e "$out/lib/julia/$file" ]; then
        target=$(realpath "$out/lib/julia/$file")
        case "$target" in
          "$out"/*)
            patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$target"
            ;;
        esac
      fi
    done
  '';

  # Code signing is done as part of the build process, but that
  # doesn't quite work so we re-sign it here.
  postFixup =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      codesign -s - --force --entitlements ./contrib/mac/app/Entitlements.plist $out/bin/julia
    ''
    + lib.optionalString useSystemNetworkStack ''
      # Julia's installer copies or symlinks the system libraries into
      # lib/julia under their unversioned names (libssl.so etc.), but the
      # stdlib JLL stubs dlopen their exact sonames (libssl.so.3 etc.),
      # which can only be resolved through the library search path of the
      # caller (libjulia-internal). Additionally, libjulia-codegen and lld
      # depend directly on system zlib and zstd, but CMake install RPATH only
      # points to lib/julia. Because patchelf --shrink-rpath in the fixup phase
      # would drop non-NEEDED rpaths, add them here in postFixup.
      ${lib.optionalString stdenv.hostPlatform.isElf ''
        for target in "$out/lib/julia/libjulia-internal.so" "$out/lib/julia/libjulia-codegen.so" "$out/libexec/julia/lld"; do
          if [ -e "$target" ]; then
            patchelf --add-rpath "${lib.makeLibraryPath networkStackLibs}" "$target"
          fi
        done
      ''}
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        for target in "$out/lib/julia/libjulia-internal.dylib" "$out/lib/julia/libjulia-codegen.dylib" "$out/libexec/julia/lld"; do
          if [ -e "$target" ]; then
            ${lib.concatMapStringsSep "\n    " (p: ''
              install_name_tool -add_rpath "${lib.getLib p}/lib" "$target"
            '') networkStackLibs}
            codesign -s - --force "$target"
          fi
        done
      ''}
    '';

  # tests are flaky for aarch64-linux on hydra
  # some tests not working on aarch64-darwin for unrelated reasons
  doInstallCheck =
    stdenv.hostPlatform.isLinux
    && (lib.versionAtLeast version "1.10" || !stdenv.hostPlatform.isAarch64);

  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    # Command lifted from `test/Makefile`.
    $out/bin/julia \
      --check-bounds=yes \
      --startup-file=no \
      --depwarn=error \
      $out/share/julia/test/runtests.jl \
      --skip internet_required ${toString skip_tests}
    runHook postInstallCheck
  '';

  postInstallCheck = lib.optionalString useSystemNetworkStack ''
    # Smoke-test that devendored stdlib JLL stubs can be loaded and dlopened
    $out/bin/julia --startup-file=no -e '
      using OpenSSL_jll, LibCURL_jll, LibGit2_jll, LibSSH2_jll, nghttp2_jll, Zlib_jll
      ${lib.optionalString (lib.versionAtLeast version "1.13") "using Zstd_jll"}
    '
    if [ -f "$out/libexec/julia/lld" ]; then
      "$out/libexec/julia/lld" -flavor gnu --version
    fi
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    mainProgram = "julia";
    homepage = "https://julialang.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nickcao
      joshniemela
      thomasjm
      taranarmo
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
