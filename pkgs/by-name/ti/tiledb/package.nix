{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  lz4,
  bzip2,
  zstd,
  spdlog,
  tbb,
  openssl,
  boost,
  libpqxx,
  clang-tools,
  catch2_3,
  python3,
  doxygen,
  fixDarwinDylibNames,
  gtest,
  rapidcheck,
  libpng,
  libwebp,
  file,
  runCommand,
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
  version = "2.27.2";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    tag = version;
    hash = "sha256-zk4jkXJMh6wpuEKaCvuKUDod+F8B/6W5Lw8gwelcPEM=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./generate_embedded_data_header.patch ];

  # libcxx (as of llvm-19) does not yet support `stop_token` and `jthread`
  # without the -fexperimental-library flag. Tiledb adds its own
  # implementations in the std namespace which conflict with libcxx. This
  # test can be re-enabled once libcxx supports stop_token and jthread.
  postPatch =
    lib.optionalString (stdenv.cc.libcxx != null) ''
      truncate -s0 tiledb/stdx/test/CMakeLists.txt
    ''
    + ''
      substituteInPlace tiledb/sm/misc/test/unit_parse_argument.cc \
        --replace-fail '"catch.hpp"' '<catch2/catch_all.hpp>'
    '';

  env.TILEDB_DISABLE_AUTO_VCPKG = "1";

  # (bundled) blosc headers have a warning on some archs that it will be using
  # unaccelerated routines.
  cmakeFlags = [
    "-DTILEDB_WEBP=ON"
    "-DTILEDB_WERROR=OFF"
    (lib.cmakeBool "TILEDB_TESTS" doCheck)
    (lib.cmakeBool "TILEDB_ARROW_TESTS" false)
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ] ++ lib.optional (!useAVX2) "-DCOMPILER_SUPPORTS_AVX2=FALSE";

  nativeBuildInputs = [
    clang-tools
    cmake
    python3
    doxygen
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    zlib
    lz4
    bzip2
    zstd
    spdlog
    tbb
    openssl
    boost
    libpqxx
    libpng
    libwebp
    file
    rapidcheck'
  ];

  nativeCheckInputs = [
    gtest
  ];

  checkInputs = [
    catch2_3
  ];

  strictDeps = true;

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

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installTargets = [
    "install-tiledb"
    "doc"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath ${tbb}/lib $out/lib/libtiledb.dylib
  '';

  meta = {
    description = "TileDB allows you to manage the massive dense and sparse multi-dimensional array data";
    homepage = "https://github.com/TileDB-Inc/TileDB";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rakesh4g ];
    # Tries to compile magic file using tool built for host.
    # https://github.com/TileDB-Inc/TileDB/blob/main/ports/libmagic/CMakeLists.txt
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
