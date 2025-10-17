{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  ninja,
  cups,
  curl,
  libGL,
  qtbase,
  qt5compat,
  qtcreator,
  vulkan-headers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qodeassist-plugin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Palm1r";
    repo = "QodeAssist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XzxuElQQxR2dK7KD0QHUAb7qyizUBhPvGDv3OvnAQjc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    (qttools.override { withClang = true; })
  ];

  buildInputs = [
    cups
    curl
    libGL
    qtbase
    qt5compat
    qtcreator
    vulkan-headers
  ];

  outputs = [ "out" ];

  cmakeFlags = [ ];

  installPhase = "mkdir -p $out; cp -R lib $out/";

  meta = {
    description = "AI-powered coding assistant plugin for Qt Creator";
    longDescription = ''
      QodeAssist is an AI-powered coding assistant plugin for Qt Creator.
      It provides intelligent code completion and suggestions for C++ and QML,
      leveraging large language models through local providers like Ollama.
      Enhance your coding productivity with context-aware AI assistance directly
      in your Qt development environment.
    '';
    homepage = "https://github.com/Palm1r/QodeAssist";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.zatm8 ];
    platforms = lib.platforms.linux;
  };
})
