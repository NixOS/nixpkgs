{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  i3,
  jsoncpp,
  libsigcxx,
  libx11,
  libxkbfile,
  pkg-config,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkb-switch-i3";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Zebradil";
    repo = "xkb-switch-i3";
    tag = finalAttrs.version;
    hash = "sha256-5d1DdRtz0QCWISSsWQt9xgTOekYUCkhfMsjG+/kyQK4=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "bump-cmake-required-version.patch";
      url = "https://github.com/Zebradil/xkb-switch-i3/commit/95f6ff96c77fc17891d57332f6d3a014500396eb.patch?full_index=1";
      hash = "sha256-J8EITYxi5EpYwROmFrAXgqFgbnFh8/fy9nxEKNhBvek=";
    })
  ];

  postPatch = ''
    substituteInPlace i3ipc++/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0 FATAL_ERROR)" \
        "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    i3
    jsoncpp
    libsigcxx
    libx11
    libxkbfile
  ];

  meta = {
    description = "Switch your X keyboard layouts from the command line(i3 edition)";
    homepage = "https://github.com/Zebradil/xkb-switch-i3";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ewok ];
    platforms = lib.platforms.linux;
    mainProgram = "xkb-switch";
  };
})
