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
  fmt,
  nanobench,
  spdlog,
  tt-logger,
  cxxopts,
  hwloc,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-umd";
  version = "0.9.12";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-umd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lhcNZuCV8n3ebbUU1MveZXR49qaybmOiSTLpitG96/s=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  patches = [
    # https://github.com/tenstorrent/tt-umd/pull/3593
    ./link-shared-yaml-cpp-into-baremetal-tests.patch
  ];

  postPatch = ''
    cp $cpm cmake/CPM.cmake
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    fmt
    yaml-cpp
    nanobench
    spdlog
    tt-logger
    cxxopts
    python3.pkgs.nanobind
    hwloc
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeFeature "umd_asio_SOURCE_DIR" (
      builtins.toString (fetchFromGitHub {
        owner = "chriskohlhoff";
        repo = "asio";
        tag = "asio-1-30-2";
        hash = "sha256-g+ZPKBUhBGlgvce8uTkuR983unD2kbQKgoddko7x+fk=";
      })
    ))
    (lib.cmakeBool "TT_UMD_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "TT_UMD_BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "TT_UMD_BUILD_PYTHON" true)
    (lib.cmakeBool "CMAKE_COMPILE_WARNING_AS_ERROR" false)
    (lib.cmakeFeature "nanobind_DIR" "${python3.pkgs.nanobind}/${python3.sitePackages}/nanobind/cmake")
  ];

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}
    mv $out/tt_umd $out/${python3.sitePackages}/tt_umd
    rm $out/libtt-umd.so.*

    mkdir -p $out/${python3.sitePackages}/tt_umd-${finalAttrs.version}.dist-info
    cat > $out/${python3.sitePackages}/tt_umd-${finalAttrs.version}.dist-info/METADATA <<EOF
    Metadata-Version: 2.1
    Name: tt-umd
    Version: ${finalAttrs.version}
    EOF
  '';

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = {
    description = "User-Mode Driver for Tenstorrent hardware";
    homepage = "https://github.com/tenstorrent/tt-umd";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
