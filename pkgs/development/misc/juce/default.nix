{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # Native build inputs
  cmake,
  pkg-config,
  makeWrapper,

  # Dependencies
  alsa-lib,
  freetype,
  curl,
  libglvnd,
  webkitgtk_4_0,
  pcre2,
  libsysprof-capture,
  util-linuxMinimal,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libXdmcp,
  lerc,
  libxkbcommon,
  libepoxy,
  libXtst,
  sqlite,
  fontconfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "8.0.4";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = finalAttrs.version;
    hash = "sha256-iAueT+yHwUUHOzqfK5zXEZQ0GgOKJ9q9TyRrVfWdewc=";
  };

  patches = [
    # Adapted from https://gitlab.archlinux.org/archlinux/packaging/packages/juce/-/raw/4e6d34034b102af3cd762a983cff5dfc09e44e91/juce-6.1.2-cmake_install.patch
    # for Juce 8.0.4.
    ./juce-8.0.4-cmake_install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs =
    [
      freetype # libfreetype.so
      curl # libcurl.so
      (lib.getLib stdenv.cc.cc) # libstdc++.so libgcc_s.so
      pcre2 # libpcre2.pc
      libsysprof-capture
      libthai
      libdatrie
      lerc
      libepoxy
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib # libasound.so
      libglvnd # libGL.so
      webkitgtk_4_0 # webkit2gtk-4.0
      util-linuxMinimal
      libselinux
      libsepol
      libXdmcp
      libxkbcommon
      libXtst
    ];

  propagatedBuildInputs = [ fontconfig ];

  meta = with lib; {
    description = "Cross-platform C++ application framework";
    mainProgram = "juceaide";
    longDescription = "Open-source cross-platform C++ application framework for creating desktop and mobile applications, including VST, VST3, AU, AUv3, AAX and LV2 audio plug-ins";
    homepage = "https://juce.com/";
    changelog = "https://github.com/juce-framework/JUCE/blob/${finalAttrs.version}/CHANGE_LIST.md";
    license = with licenses; [
      agpl3Only # Or alternatively the JUCE license, but that would not be included in nixpkgs then
    ];
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.all;
  };
})
