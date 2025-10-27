{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  jq,
  expat,
  jsoncpp,
  libX11,
  libXdmcp,
  libXrandr,
  libffi,
  libxcb,
  pkg-config,
  wayland,
  which,
  xcbutilkeysyms,
  xcbutilwm,
  valijson,
  vulkan-headers,
  vulkan-loader,
  vulkan-utility-libraries,
  writeText,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools-lunarg";
  version = "1.4.328.0";

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "VulkanTools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-kywAcpBYLSlhEbgssXGwMoXQC03QUEz4dwsvI0I8Nh4=";
  };

  nativeBuildInputs = [
    cmake
    python3
    jq
    which
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    expat
    jsoncpp
    libX11
    libXdmcp
    libXrandr
    libffi
    libxcb
    valijson
    vulkan-headers
    vulkan-loader
    vulkan-utility-libraries
    wayland
    xcbutilkeysyms
    xcbutilwm
    qt6.qtbase
    qt6.qtwayland
  ];

  cmakeFlags = [
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  preConfigure = ''
    patchShebangs scripts/*
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  meta = with lib; {
    description = "LunarG Vulkan Tools and Utilities";
    longDescription = ''
      Tools to aid in Vulkan development including useful layers, trace and
      replay, and tests.
    '';
    homepage = "https://github.com/LunarG/VulkanTools";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ ];
  };
}
