{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3Packages
, vulkan-headers
, vulkan-loader
, shaderc
, lcms2
, libGL
, libX11
, libunwind
, libdovi
, xxHash
, fast-float
, vulkanSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "6.338.2";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gE6yKnFvsOFh8bFYc7b+bS+zmdDU7jucr0HwhdDeFzU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.jinja2
    python3Packages.glad2
  ];

  buildInputs = [
    shaderc
    lcms2
    libGL
    libX11
    libunwind
    libdovi
    xxHash
    vulkan-headers
  ] ++ lib.optionals vulkanSupport [
    vulkan-loader
  ] ++ lib.optionals (!stdenv.cc.isGNU) [
    fast-float
  ];

  mesonFlags = with lib; [
    (mesonBool "demos" false) # Don't build and install the demo programs
    (mesonEnable "d3d11" false) # Disable the Direct3D 11 based renderer
    (mesonEnable "glslang" false) # rely on shaderc for GLSL compilation instead
    (mesonEnable "vk-proc-addr" vulkanSupport)
    (mesonOption "vulkan-registry" "${vulkan-headers}/share/vulkan/registry/vk.xml")
  ] ++ optionals stdenv.isDarwin [
    (mesonEnable "unwind" false) # libplacebo doesn’t build with `darwin.libunwind`
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace 'python_env.append' '#'
  '';

  meta = with lib; {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    longDescription = ''
      Reusable library for GPU-accelerated image/view processing primitives and
      shaders, as well a batteries-included, extensible, high-quality rendering
      pipeline (similar to mpv's vo_gpu). Supports Vulkan, OpenGL and Metal (via
      MoltenVK).
    '';
    homepage = "https://code.videolan.org/videolan/libplacebo";
    changelog = "https://code.videolan.org/videolan/libplacebo/-/tags/v${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ primeos tadeokondrak ];
    platforms = platforms.all;
  };
}
