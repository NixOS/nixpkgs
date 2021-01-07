{ stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, python3Packages
, vulkan-headers
, vulkan-loader
, shaderc
, glslang
, lcms2
, epoxy
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "2.72.2";

  patches = [
    (fetchpatch {
      # support glslang>=11.0.0; Upstream MR: https://code.videolan.org/videolan/libplacebo/-/merge_requests/131
      url = "https://code.videolan.org/videolan/libplacebo/-/commit/affd15a2faa1340d40dcf277a8acffe2987f517c.patch";
      sha256 = "1nm27mdm9rn3wsbjdif46pici6mbzmfb6521ijl8ah4mxn9p1ikc";
    })
  ];

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ijqpx1pagc6qg63ynqrinvckwc8aaw1i0lx48gg5szwk8afib4i";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.Mako
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    shaderc
    glslang
    lcms2
    epoxy
  ];

  mesonFlags = [
    "-Dvulkan-registry=${vulkan-headers}/share/vulkan/registry/vk.xml"
  ];

  meta = with stdenv.lib; {
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
