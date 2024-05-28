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

  # The intent is to mirror vcpkg's flags[^1],
  # but we only actually support Linux and glfw3 until someone contributes the rest
  # [^1]: https://github.com/microsoft/vcpkg/blob/095ee06e7f60dceef7d713e3f8b1c2eb10d650d7/ports/imgui/CMakeLists.txt#L33-L108
  IMGUI_BUILD_ALLEGRO5_BINDING ? false,
  IMGUI_BUILD_ANDROID_BINDING ? stdenv.hostPlatform.isAndroid,
  IMGUI_BUILD_DX9_BINDING ? false,
  IMGUI_BUILD_DX10_BINDING ? false,
  IMGUI_BUILD_DX11_BINDING ? false,
  IMGUI_BUILD_DX12_BINDING ? false,
  IMGUI_BUILD_GLFW_BINDING ? !stdenv.isDarwin,
  IMGUI_BUILD_GLUT_BINDING ? false,
  IMGUI_BUILD_METAL_BINDING ? stdenv.isDarwin,
  IMGUI_BUILD_OPENGL2_BINDING ? false,
  IMGUI_BUILD_OPENGL3_BINDING ?
    IMGUI_BUILD_SDL2_BINDING || IMGUI_BUILD_GLFW_BINDING || IMGUI_BUILD_GLUT_BINDING,
  IMGUI_BUILD_OSX_BINDING ? stdenv.isDarwin,
  IMGUI_BUILD_SDL2_BINDING ?
    !IMGUI_BUILD_GLFW_BINDING && !stdenv.isDarwin,
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
        url = "https://github.com/microsoft/vcpkg/commit/e91750f08383112e8850f209e55ed2f960181fa6.patch";
        hash = "sha256-T+DN42PRl2gWGM8zJb9wZEsDl7+XNT6CFypNX3lBHNc=";
      })
    ];
  };
in

stdenv.mkDerivation rec {
  pname = "imgui";
  version = "1.90.6";
  outputs = [
    # Note: no "dev" because vcpkg installs include/ and imgui-config.cmake
    # into different prefixes but expects the merged layout at import time
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v${version}";
    sha256 = "sha256-FSob6FPfg0tF0n72twA5/moLvEaB251BPkIDJUXhYbg=";
  };

  cmakeRules = "${vcpkgSource}/ports/imgui";
  postPatch = ''
    cp "$cmakeRules"/{CMakeLists.txt,*.cmake.in} ./
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.ApplicationServices
  ];

  propagatedBuildInputs =
    lib.optionals (IMGUI_BUILD_OPENGL2_BINDING || IMGUI_BUILD_OPENGL3_BINDING) [ libGL ]
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
      wolfangaukang
    ];
    platforms = lib.platforms.all;
  };
}
