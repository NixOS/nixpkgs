{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  python3,
  ninja,
  pkg-config,
  verilator,
  verible,
  fmt,
  boost182,
  sv-lang,
  catch2_3,
  openssl,
  lib,
  writeText,
}:

let
  fmtver = "11.1.3";
  fmtsrc = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    tag = fmtver;
    hash = "sha256-6r9D/csVSgS+T/H0J8cSR+YszxnH/h2V2odi2s6VYN8=";
  };

  fmtlib = fmt.overrideAttrs (oldAttrs: {
    version = fmtver;
    src = fmtsrc;
  });

  boostlib = boost182;

  slang-git =
    let
      version = "8.0";
    in
    sv-lang.overrideAttrs (old: {
      version = version;
      src = fetchFromGitHub {
        owner = "MikePopoloski";
        repo = "slang";
        tag = "v${version}";
        hash = "sha256-UZwMxnzprOjN5DlV1zLd0I6rgrBMBhcZ+dSx8t2sJF8=";
      };
      cmakeFlags = [
        "-DCMAKE_INSTALL_INCLUDEDIR=include"
        "-DCMAKE_INSTALL_LIBDIR=lib"
        "-DSLANG_INCLUDE_TESTS=${if stdenv.hostPlatform.isDarwin then "OFF" else "ON"}"
        "-DSLANG_USE_MIMALLOC=OFF"
        "-DFETCHCONTENT_SOURCE_DIR_FMT=${fmtsrc}"
      ];
      nativeBuildInputs = [
        cmake
        python3
        ninja
      ];
      buildInputs = [
        (stdenv.mkDerivation rec {
          pname = "unordered_dense";
          version = "2.0.1";
          src = fetchFromGitHub {
            owner = "martinus";
            repo = "unordered_dense";
            tag = "v${version}";
            hash = "sha256-9zlWYAY4lOQsL9+MYukqavBi5k96FvglRgznLIwwRyw=";
          };
          nativeBuildInputs = [ cmake ];
          installPhase = "runHook preInstall; mkdir -p $out/include; cp -r . $out/include";
        })
        boostlib
        fmtlib
        catch2_3
      ];
    });
in
rustPlatform.buildRustPackage {
  pname = "veridian";
  version = "0-unstable-2024-12-25";
  src = fetchFromGitHub {
    owner = "vivekmalneedi";
    repo = "veridian";
    rev = "d094c9d2fa9745b2c4430eef052478c64d5dd3b6";
    hash = "sha256-3KjUunXTqdesvgDSeQMoXL0LRGsGQXZJGDt+xLWGovM=";
  };

  cargoHash = "sha256-qJQD9HjSrrHdppbLNgLnXCycgzbmPePydZve3A8zGtU=";
  useFetchCargoVendor = true;

  buildFeatures = [ "slang" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    cmake
    verilator
    verible
  ];

  buildInputs = [
    fmtlib
    verible
    slang-git
  ];

  patches = [
    (writeText "slang-cmake-patch" ''
      diff --git a/veridian-slang/build.rs b/veridian-slang/build.rs
      index d42c02d..2b1e745 100644
      --- a/veridian-slang/build.rs
      +++ b/veridian-slang/build.rs
      @@ -43,7 +43,7 @@ fn build_slang(slang_src: &Path, slang_install: &Path) {
       fn build_slang_wrapper(slang: &Path, wrapper_install: &Path) {
           cmake::Config::new("slang_wrapper")
               .profile("Release")
      -        .define("CMAKE_PREFIX_PATH", slang)
      +        .define("CMAKE_PREFIX_PATH", slang.join(";${fmtlib.dev};${boostlib.dev}"))
               .out_dir(wrapper_install)
               .build();
       }
    '')
    (writeText "slang-version-patch" ''
      diff --git a/veridian-slang/slang_wrapper/CMakeLists.txt b/veridian-slang/slang_wrapper/CMakeLists.txt
      index a3cf824..9941e92 100644
      --- a/veridian-slang/slang_wrapper/CMakeLists.txt
      +++ b/veridian-slang/slang_wrapper/CMakeLists.txt
      @@ -6,7 +6,7 @@ project(
       )

       # Keep the version the same as the one in `build.rs`
      -find_package(slang 7.0 REQUIRED)
      +find_package(slang 8.0 REQUIRED)

       set(CMAKE_CXX_STANDARD 20)
       set(CMAKE_CXX_STANDARD_REQUIRED ON)
    '')
  ];

  # Environment variables required for building the slang wrapper.
  env = {
    SLANG_INSTALL_PATH = slang-git;
    OPENSSL_NO_VENDOR = "1";
    OPENSSL_DIR = openssl.dev;
    OPENSSL_LIB_DIR = "${openssl.out}/lib";
  };

  meta = {
    description = "SystemVerilog Language Server";
    homepage = "https://github.com/vivekmalneedi/veridian";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hakan-demirli ];
  };
}
