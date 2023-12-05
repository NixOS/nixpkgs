{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, vulkan-headers
, vulkan-loader
, x264
, xorg
, eigen
, boost
, glm
, spdlog
, monado
, openxr-loader
, nlohmann_json
, harfbuzz
, freetype
, glslang
, python3
, udev
, ffmpeg
, libva
, libdrm
, avahi
, libpulseaudio
, pkgs
}:
let
  # We need tiny_gltf.h and draco doesn't provide it
  tinygltf = pkgs.callPackage "${pkgs.path}/pkgs/development/libraries/draco/tinygltf.nix" {};

  # The commit of monado specified in CMakeLists.txt
  vendorMonado = monado.overrideAttrs rec {
    postInstall = ''
      mv src/xrt/compositor/libcomp_main.a $out/lib/libcomp_main.a
    '';
    version = "79bf8eb8fa168f65f4e5505e0525ee74aa88783e";
    src = pkgs.fetchgit {
      url = "https://gitlab.freedesktop.org/monado/monado.git";
      rev = version;
      hash = "sha256-lzvu8xw/10pMP4pWzEDYKKoBL6GbzsmbeOCqLsuN2lk=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "wivrn";
  version = "0.10.1";

  CPM_LOCAL_PACKAGES_ONLY = "ON";

  src = fetchFromGitHub {
    owner = "Meumeu";
    repo = "WiVRn";
#    rev = version;
#    hash = "sha256-3+ljuRLrhs0j6AYjGcfPKNR7byk6qnFk3COLefNu85A=";
    rev = "v${version}";
    hash = "sha256-e9wcy9t2SdumQ+8I1pPUVuPOwnD+CK3NUZvOAAUXs4w=";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
    x264
    eigen
    boost
    glm
    spdlog
    vendorMonado
    tinygltf
    xorg.libX11
    xorg.libXrandr
    openxr-loader
    nlohmann_json
    harfbuzz
    freetype
    glslang
    udev
    ffmpeg
    libva
    libdrm
    avahi
    libpulseaudio
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace 'FetchContent_Declare(boostpfr      URL https://github.com/boostorg/pfr/archive/refs/tags/2.0.3.tar.gz)' "find_package(Boost COMPONENTS headers)"

    substituteInPlace server/CMakeLists.txt \
      --replace 'Boost::pfr' 'Boost::headers'

    substituteInPlace common/CMakeLists.txt \
      --replace 'FetchContent_MakeAvailable(boostpfr)' "find_package(Boost COMPONENTS headers)" \
      --replace 'target_link_libraries(wivrn-common PUBLIC Boost::pfr)' 'target_link_libraries(wivrn-common PUBLIC Boost::headers)'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_FREETYPE=1"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-DFETCHCONTENT_SOURCE_DIR_MONADO=${vendorMonado.src}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=1"
  ];

  postFixup = ''
    substituteInPlace $out/share/openxr/1/openxr_wivrn.json --replace "../../../" ""
  '';

  meta = with lib; {
    description = "An OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/Meumeu/WiVRn/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "wivrn-server";
    platforms = platforms.all;
  };
}
