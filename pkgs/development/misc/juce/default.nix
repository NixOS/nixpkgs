{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

# Native build inputs
, cmake
, pkg-config
, makeWrapper

# Dependencies
, alsa-lib
, freetype
, curl
, libglvnd
, webkitgtk
, pcre
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "7.0.7";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = finalAttrs.version;
    hash = "sha256-r+Wf/skPDexm3rsrVBoWrygKvV9HGlCQd7r0iHr9avM=";
  };

  patches = [
    (fetchpatch {
      name = "juce-6.1.2-cmake_install.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/juce/-/raw/4e6d34034b102af3cd762a983cff5dfc09e44e91/juce-6.1.2-cmake_install.patch";
      hash = "sha256-fr2K/dH0Zam5QKS63zos7eq9QLwdr+bvQL5ZxScagVU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    freetype # libfreetype.so
    curl # libcurl.so
    stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
    pcre # libpcre2.pc
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib # libasound.so
    libglvnd # libGL.so
    webkitgtk # webkit2gtk-4.0
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Cocoa
    darwin.apple_sdk_11_0.frameworks.MetalKit
    darwin.apple_sdk_11_0.frameworks.WebKit
  ];

  meta = with lib; {
    description = "Cross-platform C++ application framework";
    longDescription = "JUCE is an open-source cross-platform C++ application framework for desktop and mobile applications, including VST, VST3, AU, AUv3, RTAS and AAX audio plug-ins";
    homepage = "https://github.com/juce-framework/JUCE";
    license = with licenses; [ isc gpl3Plus ];
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.all;
  };
})
