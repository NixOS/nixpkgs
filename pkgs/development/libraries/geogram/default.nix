{ lib
, stdenv
, fetchurl
, fetchFromGitHub

, cmake
, doxygen
, zlib
, python3Packages
}:

let
  testdata = fetchFromGitHub {
    owner = "BrunoLevy";
    repo = "geogram.data";
    rev = "43dd49054a78d9b3fb8ef729f48ab47a272c718c";
    hash = "sha256-F2Lyt4nEOczVYLz6WLny+YrsxNwREBGPkProN8NHFN4=";
  };
in
stdenv.mkDerivation rec {
  pname = "geogram";
  version = "1.8.6";

  src = fetchurl {
    url = "https://github.com/BrunoLevy/geogram/releases/download/v${version}/geogram_${version}.tar.gz";
    hash = "sha256-Xqha5HVqD2Ao0z++RKcQdMZUmtMb5eZ1DMJEVrfNUzE=";
  };

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  cmakeFlags = [
    # Triangle is unfree
    "-DGEOGRAM_WITH_TRIANGLE=OFF"

    # Disable some extra features (feel free to create a PR if you need one of those)

    # If GEOGRAM_WITH_LEGACY_NUMERICS is enabled GeoGram will build its own version of
    # ARPACK, CBLAS, CLAPACK, LIBF2C and SUPERLU
    "-DGEOGRAM_WITH_LEGACY_NUMERICS=OFF"

    # Don't build Lua
    "-DGEOGRAM_WITH_LUA=OFF"

    # Disable certain features requiring GLFW
    "-DGEOGRAM_WITH_GRAPHICS=OFF"

    # NOTE: Options introduced by patch (see below)
    "-DGEOGRAM_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    "-DGEOGRAM_INSTALL_PKGCONFIG_DIR=${placeholder "dev"}/lib/pkgconfig"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    zlib
  ];

  patches = [
    # This patch replaces the bundled (outdated) zlib with our zlib
    # Should be harmless, but if there are issues this patch can also be removed
    # Also check https://github.com/BrunoLevy/geogram/issues/49 for progress
    ./replace-bundled-zlib.patch
  ];

  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace cmake/platforms/*/config.cmake \
      --replace "-m64" ""
  '';

  postBuild = ''
    make doc-devkit-full
  '';

  nativeCheckInputs = [
    python3Packages.robotframework
  ];

  doCheck = true;

  checkPhase =
    let
      skippedTests = [
        # Failing tests as of version 1.8.3
        "FileConvert"
        "Reconstruct"
        "Remesh"

        # Skip slow RVD test
        "RVD"

        # Flaky as of 1.8.5 (SIGSEGV, possibly a use-after-free)
        "Delaunay"
      ];
    in
    ''
      runHook preCheck

      ln -s ${testdata} ../tests/data

      source tests/testenv.sh
      robot \
        ${lib.concatMapStringsSep " " (t: lib.escapeShellArg "--skip=${t}") skippedTests} \
        ../tests

      runHook postCheck
    '';

  meta = with lib; {
    description = "Programming Library with Geometric Algorithms";
    longDescription = ''
      Geogram contains the main results in Geometry Processing from the former ALICE Inria project,
      that is, more than 30 research articles published in ACM SIGGRAPH, ACM Transactions on Graphics,
      Symposium on Geometry Processing and Eurographics.
    '';
    homepage = "https://github.com/BrunoLevy/geogram";
    license = licenses.bsd3;

    # Broken on aarch64-linux as of version 1.8.3
    # See https://github.com/BrunoLevy/geogram/issues/74
    broken = stdenv.isLinux && stdenv.isAarch64;

    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ tmarkus ];
  };
}
