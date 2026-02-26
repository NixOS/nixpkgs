{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  gtest,
  yaml-cpp,
  fmt_11,
  nanobench,
  spdlog,
  tt-logger,
  cxxopts,
  nanobind,
  hwloc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-umd";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-umd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQ1rRE7FV1H9B6fiPCbP64qq4J/jqdwGHDXjwUgmVD8=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  patches = [
    # https://github.com/tenstorrent/tt-umd/pull/2180
    ./fix-nanobind.patch

    # https://github.com/tenstorrent/tt-umd/pull/2181
    ./fix-picosha2.patch

    # https://github.com/tenstorrent/tt-umd/pull/2182
    ./fix-asio.patch

    # https://github.com/tenstorrent/tt-umd/pull/2184
    ./fix-packaging.patch

    # https://github.com/tenstorrent/tt-umd/pull/2187
    ./fix-targets.patch

    # https://github.com/tenstorrent/tt-umd/pull/2188
    ./fix-gtest.patch
  ];

  postPatch = ''
    cp $cpm cmake/CPM.cmake
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fmt_11
    yaml-cpp
    nanobench
    spdlog
    tt-logger
    cxxopts
    nanobind
    hwloc
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeFeature "picosha2_SOURCE_DIR" (
      builtins.toString (fetchFromGitHub {
        owner = "okdshin";
        repo = "PicoSHA2";
        tag = "v1.0.1";
        hash = "sha256-3psCzbrwR+vO9TyTKOx+gEaWuHDx6pSgLOQ3DqrJsnI=";
      })
    ))
    (lib.cmakeFeature "umd_asio_SOURCE_DIR" (
      builtins.toString (fetchFromGitHub {
        owner = "chriskohlhoff";
        repo = "asio";
        tag = "asio-1-30-2";
        hash = "sha256-g+ZPKBUhBGlgvce8uTkuR983unD2kbQKgoddko7x+fk=";
      })
    ))
    (lib.cmakeBool "TT_UMD_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "TT_UMD_BUILD_STATIC" stdenv.hostPlatform.isStatic)
  ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = {
    description = "User-Mode Driver for Tenstorrent hardware";
    homepage = "https://github.com/tenstorrent/tt-umd";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
  };
})
