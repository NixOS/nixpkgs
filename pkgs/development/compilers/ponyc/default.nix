{ lib
, stdenv
, fetchFromGitHub
, callPackage
, cc ? stdenv.cc
, cmake
, coreutils
, libxml2
, lto ? !stdenv.isDarwin
, makeWrapper
, openssl
, pcre2
, pony-corral
, python3
, substituteAll
, which
, z3
}:

stdenv.mkDerivation (rec {
  pname = "ponyc";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    hash = "sha256-qFPubqGfK0WCun6QA1OveyDJj7Wf6SQpky7pEb7qsf4=";
    fetchSubmodules = true;
  };

  ponygbenchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v1.7.1";
    hash = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
  };

  nativeBuildInputs = [ cmake makeWrapper which python3 ];
  buildInputs = [ libxml2 z3 ];

  # Sandbox disallows network access, so disabling problematic networking tests
  patches = [
    ./disable-tests.patch
    (substituteAll {
      src = ./make-safe-for-sandbox.patch;
      googletest = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        # GoogleTest follows Abseil Live at Head philosophy, use latest commit from main branch as often as possible.
        rev = "1a727c27aa36c602b24bf170a301aec8686b88e8"; # unstable-2023-03-07
        hash = "sha256-/FWBSxZESwj/QvdNK5BI2EfonT64DP1eGBZR4O8uJww=";
      };
    })
  ];

  postUnpack = ''
    mkdir -p source/build/build_libs/gbenchmark-prefix/src
    cp -r "$ponygbenchmark"/ source/build/build_libs/gbenchmark-prefix/src/benchmark
    chmod -R u+w source/build/build_libs/gbenchmark-prefix/src/benchmark
  '';

  dontConfigure = true;

  postPatch = ''
    substituteInPlace packages/process/_test.pony \
        --replace '"/bin/' '"${coreutils}/bin/' \
        --replace '=/bin' "${coreutils}/bin"
    substituteInPlace src/libponyc/pkg/package.c \
        --replace "/usr/local/lib" "" \
        --replace "/opt/local/lib" ""
  '';

  preBuild = ''
    make libs build_flags=-j$NIX_BUILD_CORES
    make configure build_flags=-j$NIX_BUILD_CORES
  '';

  makeFlags = [
    "PONYC_VERSION=${version}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals stdenv.isDarwin ([ "bits=64" ] ++ lib.optional (!lto) "lto=no");

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=redundant-move" "-Wno-error=implicit-fallthrough" ];

  doCheck = true;

  installPhase = "make config=release prefix=$out "
    + lib.optionalString stdenv.isDarwin ("bits=64 " + (lib.optionalString (!lto) "lto=no "))
    + '' install
    wrapProgram $out/bin/ponyc \
      --prefix PATH ":" "${stdenv.cc}/bin" \
      --set-default CC "$CC" \
      --prefix PONYPATH : "${lib.makeLibraryPath [ pcre2 openssl (placeholder "out") ]}"
  '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  passthru.tests.pony-corral = pony-corral;

  meta = with lib; {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = "https://www.ponylang.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kamilchm patternspandemic redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
  };
})
