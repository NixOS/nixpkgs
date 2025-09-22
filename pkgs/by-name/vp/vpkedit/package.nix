{
  lib,
  stdenv,
  fetchgit,
  fetchFromGitHub,
  cmake,
  openssl,
  qt6,
  zlib-ng,
  bzip2,
  xz,
  zstd,
  cryptopp,
  mesa,
  pkg-config,
  makeWrapper,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpkedit";
  version = "5.0.0-beta.1";

  src = fetchFromGitHub {
    owner = "craftablescience";
    repo = "VPKEdit";
    tag = "v5.0.0.1";
    fetchSubmodules = true;
    hash = "sha256-CPL+pPVrkbTIktskRsgHHgarg4edf0s3U2pnJ5/6h8E=";
  };

  # The following sources should be updated according to what was available
  # at the time of VPKEdit's release, according to the vendored submodules
  # and their nested submodules. These need to exist to avoid CMake's
  # FetchContent trying to pull stuff over the network.
  #
  #
  # v5.0.0.1
  # |
  # --> ext/shared/sourcepp @ 6ba306a
  #   |
  #   --> ext/cryptopp (which is actually cryptopp-cmake) @ edb9a71
  #   | |
  #   | --> sources cryptopp (the actual one) from latest release tag of https://github.com/weidai11/cryptopp
  #   |
  #   --> ext/minizip-ng @ 2c0dc5d
  #     |
  #     --> sources zlib from stable branch of https://github.com/zlib-ng/zlib-ng (pinned to latest release tag)
  #     |
  #     --> sources bzip2 from master branch of https://gitlab.com/bzip2/bzip2
  #     |   (we would use this here, but bzip2 in our pkgs still uses the sourceware repo)
  #     |
  #     --> sources xz from master branch of https://github.com/tukaani-project/xz
  #     |
  #     --> sources zstd from release branch of https://github.com/facebook/zstd (pinned to latest release tag)

  cryptopp-src = fetchgit {
    url = "https://github.com/weidai11/cryptopp.git";
    tag = "CRYPTOPP_8_9_0";
    hash = "sha256-HV+afSFkiXdy840JbHBTR8lLL0GMwsN3QdwaoQmicpQ=";
  };

  zlib-src = fetchgit {
    url = "https://github.com/zlib-ng/zlib-ng.git";
    tag = "2.2.4";
    hash = "sha256-NZgnctJ6nA8Pp+wQ70p6m01LwY3wyl4G5bnLhQZYfps=";
  };

  bzip2-src = fetchgit {
    url = "git://sourceware.org/git/bzip2.git";
    rev = "fbc4b11da543753b3b803e5546f56e26ec90c2a7";
    hash = "sha256-kg/y9ZGbvaQd86tXxekxcv+h8nbNk3UvWad50fm5FtA=";
  };

  xz-src = fetchgit {
    url = "https://github.com/tukaani-project/xz.git";
    rev = "dd4a1b259936880e04669b43e778828b60619860";
    hash = "sha256-KRHrjAKPiQw5Z/JjL8+1S08F2e70AQsOR1VFbZ9ke4c=";
  };

  zstd-src = fetchgit {
    url = "https://github.com/facebook/zstd.git";
    tag = "v1.5.7";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    bzip2
    cryptopp
    openssl
    pkg-config
    qt6.qtbase
    qt6.qttools
    xz
    zlib-ng
    zstd
    mesa
  ];

  cmakeFlags = with finalAttrs; [
    (lib.cmakeFeature "CRYPTOPP_SOURCES" "${cryptopp-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZLIB" "${zlib-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BZIP2" "${bzip2-src}")
    (lib.cmakeFeature "BZIP2_SOURCE_DIR" "${bzip2-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBLZMA" "${xz-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZSTD" "${zstd-src}")
    (lib.cmakeBool "MZ_OPENSSL" true)
  ];

  patches = [
    ./patches/fix-installer-cmake.patch
    ./patches/fix-minizip-cmake.patch
  ];

  qtWrapperArgs = [
    "--set __EGL_VENDOR_LIBRARY_DIRS ${mesa}/share/glvnd/egl_vendor.d"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/vpkeditcli";
  doInstallCheck = true;

  meta = {
    description = "CLI/GUI tool to create, read, and write several pack file formats";
    homepage = "https://github.com/craftablescience/VPKEdit";
    mainProgram = "vpkeditcli";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ srp ];
    changelog = "https://github.com/craftablescience/VPKEdit/releases/tag/v${finalAttrs.version}";
  };
})
