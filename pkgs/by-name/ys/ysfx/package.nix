{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  freetype,
  juce,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libglvnd,
}:

stdenv.mkDerivation rec {
  pname = "ysfx";
  version = "0-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "JoepVanlier";
    repo = "ysfx";
    rev = "370c91915b0f26f5051705620b0712d06753bd41";
    hash = "sha256-9PFBDUOvLCQcZvL8TsG8MVZYzdHsaKK/Pb7S5A1dJBE=";
  };

  # Provide latest dr_libs.
  dr_libs = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "e4a7765e598e9e54dc0f520b7e4416359bee80cc";
    hash = "sha256-rWabyCP47vd+EfibBWy6iQY/nFN/OXPNhkuOTSboJaU=";
  };

  # Provide latest clap-juce-extensions.
  clap-juce-extensions = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "e1f67893cc409a40c1154fa2e78c97046da24ce0";
    hash = "sha256-JHHK9GcW0CUgUbDZeOavNRKOaAI+9pECVo9UfksPnLg=";
  };

  prePatch = ''
    rmdir thirdparty/dr_libs
    ln -s ${dr_libs} thirdparty/dr_libs
    rmdir thirdparty/clap-juce-extensions
    ln -s ${clap-juce-extensions} thirdparty/clap-juce-extensions
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    juce
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    libglvnd
  ];

  cmakeFlags = [
    "-DYSFX_PLUGIN_COPY=OFF"
    "-DYSFX_PLUGIN_USE_SYSTEM_JUCE=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r ysfx_plugin_artefacts/Release/VST3 $out/lib/vst3
    cp -r ysfx_plugin_artefacts/Release/CLAP $out/lib/clap

    runHook postInstall
  '';

  meta = {
    description = "Hosting library for JSFX";
    homepage = "https://github.com/JoepVanlier/ysfx";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bitbloxhub ];
    platforms = lib.platforms.linux;
  };
}
