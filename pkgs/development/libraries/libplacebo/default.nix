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
, xorg
, libunwind
, libdovi
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "5.264.1";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YEefuEfJURi5/wswQKskA/J1UGzessQQkBpltJ0Spq8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vulkan-headers
    python3Packages.jinja2
    python3Packages.glad2
  ];

  buildInputs = [
    vulkan-loader
    shaderc
    lcms2
    libGL
    xorg.libX11
    libunwind
    libdovi
  ];

  mesonFlags = [
    "-Dvulkan-registry=${vulkan-headers}/share/vulkan/registry/vk.xml"
    "-Ddemos=false" # Don't build and install the demo programs
    "-Dd3d11=disabled" # Disable the Direct3D 11 based renderer
    "-Dglslang=disabled" # rely on shaderc for GLSL compilation instead
  ] ++ lib.optionals stdenv.isDarwin [
    "-Dunwind=disabled" # libplacebo doesn’t build with `darwin.libunwind`
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
