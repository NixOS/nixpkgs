{
  pkgs,
  lib,
  stdenv,
  fetchgit,
  fetchFromGitHub,
  cmake,
  git,
  json_c,
  libsodium,
  libuv,
  llhttp,
  openssl,
  pkg-config,
  protobufc,
  systemd,
  zlib,
}:
let
  ziti_sdk_src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti-sdk-c";
    rev = "c19242f330a4c9b1fcfb0db6bcc2e4313c2d2115";
    hash = "sha256-Te5EFk3GjVFZzI68WKp7A8R83fVikcxsysu+D+lLyvg=";
    fetchSubmodules = true;
  };
  lwip_src = fetchFromGitHub {
    owner = "lwip-tcpip";
    repo = "lwip";
    rev = "STABLE-2_2_1_RELEASE";
    hash = "sha256-8TYbUgHNv9SV3l203WVfbwDEHFonDAQqdykiX9OoM34=";
  };
  lwip_contrib_src = fetchFromGitHub {
    owner = "netfoundry";
    repo = "lwip-contrib";
    rev = "STABLE-2_1_0_RELEASE";
    hash = "sha256-Ypn/QfkiTGoKLCQ7SXozk4D/QIdo4lyza4yq3tAoP/0=";
  };
  subcommand_c_src = fetchFromGitHub {
    owner = "openziti";
    repo = "subcommands.c";
    rev = "87350797774530b6ba9c00017f0f53dd57e6c38e";
    hash = "sha256-Gz0/b9jcC1I0fmguSMkV0xiqKWq7vzUVT0Bd1F4iqkA=";
  };
  tlsuv_src = pkgs.fetchFromGitHub {
    owner = "openziti";
    repo = "tlsuv";
    rev = "v0.39.5";
    hash = "sha256-3yY7DDTM6/WsCLxB2rZErRPvkjda4azuLwVUu/1+fuQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziti-edge-tunnel";
  version = "1.7.12";

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti-tunnel-sdk-c";
    rev = "64900406faec1f02f59b73e3cdfd7e8299c40c76";
    hash = "sha256-BOaXrttXDGAAzcGACpX9RQrlxTTdrU8IqdYJtZZY44o=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Workaround for broken llhttp package
    mkdir -p patched-cmake
    cp -r ${llhttp.dev}/lib/cmake/llhttp patched-cmake/
    substituteInPlace patched-cmake/llhttp/llhttp-config.cmake \
      --replace 'set(_IMPORT_PREFIX "${llhttp}")' 'set(_IMPORT_PREFIX "${llhttp.dev}")'

    # Patch hardcoded paths to systemd tools
    substituteInPlace programs/ziti-edge-tunnel/netif_driver/linux/resolvers.h \
      --replace '"/usr/bin/busctl"' '"${systemd}/bin/busctl"' \
      --replace '"/usr/bin/resolvectl"' '"${systemd}/bin/resolvectl"' \
      --replace '"/usr/bin/systemd-resolve"' '"${systemd}/bin/systemd-resolve"'
  '';

  preConfigure = ''
    # Prepend patched cmake to path
    export CMAKE_PREFIX_PATH=$(pwd)/patched-cmake''${CMAKE_PREFIX_PATH:+:}$CMAKE_PREFIX_PATH

    # Copy dependencies
    cp -r ${ziti_sdk_src} ./deps/ziti-sdk-c
    cp -r ${lwip_src} ./deps/lwip
    cp -r ${lwip_contrib_src} ./deps/lwip-contrib
    cp -r ${subcommand_c_src} ./deps/subcommand.c
    cp -r ${tlsuv_src} ./deps/tlsuv
    chmod -R +w .
  '';

  cmakeFlags = [
    "-DENABLE_VCPKG=OFF"
    "-DDISABLE_SEMVER_VERIFICATION=ON"
    "-DDISABLE_LIBSYSTEMD_FEATURE=ON" # Disable direct integration to use resolvectl fallback
    "-DZITI_SDK_DIR=../deps/ziti-sdk-c"
    "-DZITI_SDK_VERSION=1.8.5"
    # Ensure a concrete version is embedded; upstream library stringifies ZITI_VERSION
    "-DCMAKE_C_FLAGS=-DZITI_VERSION=v${finalAttrs.version}"
    "-DCMAKE_CXX_FLAGS=-DZITI_VERSION=v${finalAttrs.version}"
    "-DFETCHCONTENT_SOURCE_DIR_LWIP=../deps/lwip"
    "-DFETCHCONTENT_SOURCE_DIR_LWIP-CONTRIB=../deps/lwip-contrib"
    "-DFETCHCONTENT_SOURCE_DIR_SUBCOMMAND=../deps/subcommand.c"
    "-DFETCHCONTENT_SOURCE_DIR_TLSUV=../deps/tlsuv"
    "-DDOXYGEN_OUTPUT_DIR=/tmp/doxygen"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  nativeBuildInputs = [
    cmake
    git
    json_c
    libsodium
    libuv
    llhttp
    openssl
    pkg-config
    protobufc
    zlib
  ];

  propagatedBuildInputs = [
    systemd # For the resolvectl command at runtime
  ];

  meta = {
    description = "provides protocol translation and other common functions that are useful to Ziti Tunnelers";
    changelog = "https://github.com/openziti/ziti-tunnel-sdk-c/releases/tag/v${finalAttrs.version}";
    homepage = "https://openziti.io/";
    maintainers = with lib.maintainers; [ andrewzah ];
    license = lib.licenses.asl20;
    mainProgram = "ziti-edge-tunnel";
  };
})
