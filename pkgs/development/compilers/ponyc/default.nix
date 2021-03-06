{ lib, stdenv, fetchFromGitHub, fetchurl, makeWrapper, pcre2, coreutils, which, openssl, libxml2, cmake, z3, substituteAll,
  cc ? stdenv.cc, lto ? !stdenv.isDarwin }:

stdenv.mkDerivation (rec {
  pname = "ponyc";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "0b93br66wdjk38yd0qvi4q9g42c2676lhsydaw5xwq6cx11bdaag";

# Due to a bug in LLVM 9.x, ponyc has to include its own vendored patched
# LLVM.  (The submodule is a specific tag in the LLVM source tree).
#
# The pony developers are currently working to get off 9.x as quickly
# as possible so hopefully in a few revisions this package build will
# become a lot simpler.
#
# https://reviews.llvm.org/rG9f4f237e29e7150dfcf04ae78fa287d2dc8d48e2

    fetchSubmodules = true;
  };

  ponygbenchmark = fetchurl {
    url = "https://github.com/google/benchmark/archive/v1.5.2.tar.gz";
    sha256 = "033hgsc76bcii1gwd8hdc7z1iqdnggk4f8cq0hzh98dsjsvxmjyw";
    name = "v1.5.2.tar.gz";
  };

  nativeBuildInputs = [ cmake makeWrapper which ];
  buildInputs = [ libxml2 z3 ];
  propagatedBuildInputs = [ cc ];

  # Sandbox disallows network access, so disabling problematic networking tests
  patches = [
    ./disable-tests.patch
    ./fix-libstdcpp-path.patch
    (substituteAll {
      src = ./make-safe-for-sandbox.patch;
      googletest = fetchurl {
        url = "https://github.com/google/googletest/archive/release-1.8.1.tar.gz";
        sha256 = "17147961i01fl099ygxjx4asvjanwdd446nwbq9v8156h98zxwcv";
        name = "release-1.8.1.tar.gz";
      };
    })
  ];

  postUnpack = ''
    mkdir -p source/build/build_libs/gbenchmark-prefix/src
    tar -C source/build/build_libs/gbenchmark-prefix/src -zxvf "$ponygbenchmark"
    mv source/build/build_libs/gbenchmark-prefix/src/benchmark-1.5.2 \
       source/build/build_libs/gbenchmark-prefix/src/benchmark
  '';

  dontConfigure = true;

  postPatch = ''
    # Patching Vendor LLVM
    patchShebangs --host build/build_libs/gbenchmark-prefix/src/benchmark/tools/*.py
    patch -d lib/llvm/src/ -p1 < lib/llvm/patches/2020-09-01-is-trivially-copyable.diff
    patch -d lib/llvm/src/ -p1 < lib/llvm/patches/2020-01-07-01-c-exports.diff
    patch -d lib/llvm/src/ -p1 < lib/llvm/patches/2019-12-23-01-jit-eh-frames.diff

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
