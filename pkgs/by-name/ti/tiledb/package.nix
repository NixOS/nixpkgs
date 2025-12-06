{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
  lz4,
  bzip2,
  zstd,
  spdlog,
  onetbb,
  openssl,
  boost,
  libpqxx,
  clang-tools,
  catch2,
  python3,
  doxygen,
  fixDarwinDylibNames,
  gtest,
  rapidcheck,
  libpng,
  file,
  runCommand,
  curl,
  capnproto,
  useAVX2 ? stdenv.hostPlatform.avx2Support,
}:

let
  rapidcheck' = runCommand "rapidcheck" { } ''
    cp -r ${rapidcheck.out} $out
    chmod -R +w $out
    cp -r ${rapidcheck.dev}/* $out
  '';
in
stdenv.mkDerivation rec {
  pname = "tiledb";
  version = "2.28.1";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    tag = version;
    hash = "sha256-Cs3Lr8I/Mu02x78d7IySG0XX4u/VAjBs4p4b00XDT5k=";
  };

  patches = [
    # capnproto was updated to 1.2 in Nixpkgs, bring TileDB codebase up to speed
    # patch only affects serialization related code, extracted from https://github.com/TileDB-Inc/TileDB/pull/5616
    (fetchpatch {
      url = "https://github.com/TileDB-Inc/TileDB/pull/5616.patch";
      relative = "tiledb/sm/serialization";
      extraPrefix = "tiledb/sm/serialization/";
      hash = "sha256-5z/eJEHl+cnWRf1sMULodJyhmNh5KinDLlL1paMNiy4=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ./generate_embedded_data_header.patch ];

  # libcxx (as of llvm-19) does not yet support `stop_token` and `jthread`
  # without the -fexperimental-library flag. Tiledb adds its own
  # implementations in the std namespace which conflict with libcxx. This
  # test can be re-enabled once libcxx supports stop_token and jthread.
  postPatch = lib.optionalString (stdenv.cc.libcxx != null) ''
    truncate -s0 tiledb/stdx/test/CMakeLists.txt
  '';

  env.TILEDB_DISABLE_AUTO_VCPKG = "1";

  # (bundled) blosc headers have a warning on some archs that it will be using
  # unaccelerated routines.
  cmakeFlags = [
    "-DTILEDB_WEBP=OFF"
    "-DTILEDB_WERROR=OFF"
    "-DTILEDB_SERIALIZATION=ON"
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ]
  ++ lib.optional (!useAVX2) "-DCOMPILER_SUPPORTS_AVX2=FALSE";

  nativeBuildInputs = [
    catch2
    clang-tools
    cmake
    python3
    doxygen
    # Required for serialization
    curl
    capnproto
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    zlib
    lz4
    bzip2
    zstd
    spdlog
    onetbb
    openssl
    boost
    libpqxx
    libpng
    file
    rapidcheck'
    catch2
  ];

  nativeCheckInputs = [
    gtest
    catch2
  ];

  # test commands taken from
  # https://github.com/TileDB-Inc/TileDB/blob/dev/.github/workflows/unit-test-runs.yml
  checkPhase = ''
    runHook preCheck

    pushd ..
    cmake --build build --target tests
    ctest --test-dir build -R '(^unit_|test_assert)' --no-tests=error
    ctest --test-dir build -R 'test_ci_asserts'
    popd

    runHook postCheck
  '';

  installTargets = [
    "install-tiledb"
    "doc"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath ${onetbb}/lib $out/lib/libtiledb.dylib
  '';

  meta = {
    description = "Allows you to manage massive dense and sparse multi-dimensional array data";
    homepage = "https://github.com/TileDB-Inc/TileDB";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
