{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  coreutils,
  libxml2,
  lto ? true,
  makeWrapper,
  openssl,
  pcre2,
  pony-corral,
  python3,
  # Not really used for anything real, just at build time.
  git,
  substituteAll,
  which,
  z3,
  cctools,
  darwin,
}:

stdenv.mkDerivation (rec {
  pname = "ponyc";
  version = "0.58.6";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    hash = "sha256-cCZo/lOvSvF19SGQ9BU2J3EBKHF9PgRBhuUVBkggF9I=";
    fetchSubmodules = true;
  };

  benchmarkRev = "1.7.1";
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${benchmarkRev}";
    hash = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
  };

  googletestRev = "1.12.1";
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${googletestRev}";
    hash = "sha256-W+OxRTVtemt2esw4P7IyGWXOonUN5ZuscjvzqkYvZbM=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    which
    python3
    git
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ cctools ];

  buildInputs = [
    libxml2
    z3
  ];

  patches =
    [
      # Sandbox disallows network access, so disabling problematic networking tests
      ./disable-networking-tests.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (substituteAll {
        src = ./fix-darwin-build.patch;
        libSystem = darwin.Libsystem;
      })
    ];

  postUnpack = ''
    mkdir -p $NIX_BUILD_TOP/deps
    tar -C "$benchmark" -cf $NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar .
    tar -C "$googletest" -cf $NIX_BUILD_TOP/deps/googletest-$googletestRev.tar .
  '';

  dontConfigure = true;

  postPatch = ''
    substituteInPlace packages/process/_test.pony \
        --replace-fail '"/bin/' '"${coreutils}/bin/' \
        --replace-fail '=/bin' "${coreutils}/bin"
    substituteInPlace src/libponyc/pkg/package.c \
        --replace-fail "/usr/local/lib" "" \
        --replace-fail "/opt/local/lib" ""

    # Replace downloads with local copies.
    substituteInPlace lib/CMakeLists.txt \
        --replace-fail "https://github.com/google/benchmark/archive/v$benchmarkRev.tar.gz" "$NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar" \
        --replace-fail "https://github.com/google/googletest/archive/release-$googletestRev.tar.gz" "$NIX_BUILD_TOP/deps/googletest-$googletestRev.tar"
  '';

  preBuild = ''
    make libs build_flags=-j$NIX_BUILD_CORES
    make configure build_flags=-j$NIX_BUILD_CORES
  '';

  makeFlags = [
    "PONYC_VERSION=${version}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin ([ "bits=64" ] ++ lib.optional (!lto) "lto=no");

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=redundant-move"
    "-Wno-error=implicit-fallthrough"
  ];

  # make: *** [Makefile:222: test-full-programs-release] Killed: 9
  doCheck = !stdenv.hostPlatform.isDarwin;

  installPhase =
    ''
      makeArgs=(config=release prefix=$out)
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeArgs+=(bits=64)
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && !lto) ''
      makeArgs+=(lto=no)
    ''
    + ''
      make "''${makeArgs[@]}" install
      wrapProgram $out/bin/ponyc \
        --prefix PATH ":" "${stdenv.cc}/bin" \
        --set-default CC "$CC" \
        --prefix PONYPATH : "${
          lib.makeLibraryPath [
            pcre2
            openssl
            (placeholder "out")
          ]
        }"
    '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  passthru.tests.pony-corral = pony-corral;

  meta = with lib; {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = "https://www.ponylang.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      kamilchm
      patternspandemic
      redvers
      numinit
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
