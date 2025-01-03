{
  stdenv,
  lib,
  applyPatches,
  callPackage,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  darwin,
  glfw,
  libGL,
  SDL2,
  vcpkg,
  vulkan-headers,
  vulkan-loader,

  # NOTE: Not coming from vcpkg
  IMGUI_LINK_GLVND ?
    !stdenv.hostPlatform.isWindows && (IMGUI_BUILD_OPENGL2_BINDING || IMGUI_BUILD_OPENGL3_BINDING),

  # The intent is to mirror vcpkg's flags[^1],
  # but we only actually support Linux and glfw3 until someone contributes the rest
  # [^1]: https://github.com/microsoft/vcpkg/blob/095ee06e7f60dceef7d713e3f8b1c2eb10d650d7/ports/imgui/CMakeLists.txt#L33-L108
  IMGUI_BUILD_ALLEGRO5_BINDING ? false,
  IMGUI_BUILD_ANDROID_BINDING ? stdenv.hostPlatform.isAndroid,
  IMGUI_BUILD_DX9_BINDING ? false,
  IMGUI_BUILD_DX10_BINDING ? false,
  IMGUI_BUILD_DX11_BINDING ? false,
  IMGUI_BUILD_DX12_BINDING ? false,
  IMGUI_BUILD_GLFW_BINDING ? !stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_GLUT_BINDING ? false,
  IMGUI_BUILD_METAL_BINDING ? stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_OPENGL2_BINDING ? false,
  IMGUI_BUILD_OPENGL3_BINDING ?
    IMGUI_BUILD_SDL2_BINDING || IMGUI_BUILD_GLFW_BINDING || IMGUI_BUILD_GLUT_BINDING,
  IMGUI_BUILD_OSX_BINDING ? stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_SDL2_BINDING ? !IMGUI_BUILD_GLFW_BINDING && !stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_SDL2_RENDERER_BINDING ? IMGUI_BUILD_SDL2_BINDING,
  IMGUI_BUILD_VULKAN_BINDING ? false,
  IMGUI_BUILD_WIN32_BINDING ? false,
  IMGUI_FREETYPE ? false,
  IMGUI_FREETYPE_LUNASVG ? false,
  IMGUI_USE_WCHAR32 ? false,
}@args:

let
  vcpkgSource = applyPatches {
    inherit (vcpkg) src;
    patches = [
      # Install imgui into split outputs:
      (fetchpatch {
        url = "https://github.com/microsoft/vcpkg/commit/4108dd75ce9731a4fdcf50fd05034405156eaddf.patch";
        hash = "sha256-jXbR0NfyuO8EESmva5A+H3WmBfCG83OiA8ZCcWsRhQA=";
      })
    ];
  };
in

stdenv.mkDerivation rec {
  pname = "imgui";
  version = "1.91.4";
  outputs = [
    # Note: no "dev" because vcpkg installs include/ and imgui-config.cmake
    # into different prefixes but expects the merged layout at import time
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-6j4keBOAzbBDsV0+R4zTNlsltxz2dJDGI43UIrHXDNM=";
  };

  cmakeRules = "${vcpkgSource}/ports/imgui";
  postPatch = ''
    cp "$cmakeRules"/{CMakeLists.txt,*.cmake.in} ./
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.ApplicationServices
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.GameController
  ];

  propagatedBuildInputs =
    lib.optionals IMGUI_LINK_GLVND [ libGL ]
    ++ lib.optionals IMGUI_BUILD_GLFW_BINDING [ glfw ]
    ++ lib.optionals IMGUI_BUILD_SDL2_BINDING [ SDL2 ]
    ++ lib.optionals IMGUI_BUILD_VULKAN_BINDING [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals IMGUI_BUILD_METAL_BINDING [ darwin.apple_sdk.frameworks.Metal ];

  cmakeFlags = [
    (lib.cmakeBool "IMGUI_BUILD_GLFW_BINDING" IMGUI_BUILD_GLFW_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_ALLEGRO5_BINDING" IMGUI_BUILD_ALLEGRO5_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_ANDROID_BINDING" IMGUI_BUILD_ANDROID_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX9_BINDING" IMGUI_BUILD_DX9_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX10_BINDING" IMGUI_BUILD_DX10_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX11_BINDING" IMGUI_BUILD_DX11_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX12_BINDING" IMGUI_BUILD_DX12_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_GLFW_BINDING" IMGUI_BUILD_GLFW_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_GLUT_BINDING" IMGUI_BUILD_GLUT_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_METAL_BINDING" IMGUI_BUILD_METAL_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OPENGL2_BINDING" IMGUI_BUILD_OPENGL2_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OPENGL3_BINDING" IMGUI_BUILD_OPENGL3_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OSX_BINDING" IMGUI_BUILD_OSX_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_SDL2_BINDING" IMGUI_BUILD_SDL2_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_SDL2_RENDERER_BINDING" IMGUI_BUILD_SDL2_RENDERER_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_VULKAN_BINDING" IMGUI_BUILD_VULKAN_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_WIN32_BINDING" IMGUI_BUILD_WIN32_BINDING)
    (lib.cmakeBool "IMGUI_FREETYPE" IMGUI_FREETYPE)
    (lib.cmakeBool "IMGUI_FREETYPE_LUNASVG" IMGUI_FREETYPE_LUNASVG)
    (lib.cmakeBool "IMGUI_USE_WCHAR32" IMGUI_USE_WCHAR32)
  ];

  passthru = {
    tests = {
      demo = callPackage ./demo { };
    };
  };

  meta = {
    # These flags haven't been tested:
    broken =
      IMGUI_FREETYPE
      || IMGUI_FREETYPE_LUNASVG
      || IMGUI_BUILD_DX9_BINDING
      || IMGUI_BUILD_DX10_BINDING
      || IMGUI_BUILD_DX11_BINDING
      || IMGUI_BUILD_DX12_BINDING
      || IMGUI_BUILD_WIN32_BINDING
      || IMGUI_BUILD_ALLEGRO5_BINDING
      || IMGUI_BUILD_ANDROID_BINDING;
    description = "Bloat-free Graphical User interface for C++ with minimal dependencies";
    homepage = "https://github.com/ocornut/imgui";
    license = lib.licenses.mit; # vcpkg licensed as MIT too
    maintainers = with lib.maintainers; [
      SomeoneSerge
    ];
    platforms = lib.platforms.all;
  };
}
