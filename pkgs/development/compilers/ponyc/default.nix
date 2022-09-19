{ lib, stdenv, fetchFromGitHub, fetchurl, makeWrapper, pcre2, coreutils, which, openssl, libxml2, cmake, z3, substituteAll, python3,
  cc ? stdenv.cc, lto ? !stdenv.isDarwin }:

stdenv.mkDerivation (rec {
  pname = "ponyc";
  version = "0.51.2";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "sha256-hQvdVXNGEEbr4a0wjp/kEpdDsTXaRCpq+8jXUvTEZEI=";

    fetchSubmodules = true;
  };

  ponygbenchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v1.5.6";
    sha256 = "sha256-DFm5cQh1b2BX6qCDaQZ1/XBNDeIYXKWbIETYu1EjDww=";
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
        rev = "release-1.11.0";
        sha256 = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
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
    # Patching Vendor LLVM
    patchShebangs --host build/build_libs/gbenchmark-prefix/src/benchmark/tools/*.py
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
  ]
    ++ lib.optionals stdenv.isDarwin [ "bits=64" ]
    ++ lib.optionals (stdenv.isDarwin && (!lto)) [ "lto=no" ];

  doCheck = true;

  NIX_CFLAGS_COMPILE = [ "-Wno-error=redundant-move" "-Wno-error=implicit-fallthrough" ];

  installPhase = "make config=release prefix=$out "
    + lib.optionalString stdenv.isDarwin "bits=64 "
    + lib.optionalString (stdenv.isDarwin && (!lto)) "lto=no "
    + '' install
    wrapProgram $out/bin/ponyc \
      --prefix PATH ":" "${stdenv.cc}/bin" \
      --set-default CC "$CC" \
      --prefix PONYPATH : "${lib.makeLibraryPath [ pcre2 openssl (placeholder "out") ]}"
  '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  meta = with lib; {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = "https://www.ponylang.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kamilchm patternspandemic redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
