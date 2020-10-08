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
  version = "2.72.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yhf9xyxdawbihsx89dpjlac800wrmpwx63rphad2nj225y9q40f";
  };

  patches = [
    # to work with latest glslang, remove on release >2.72.0
    (fetchpatch {
      url = "https://code.videolan.org/videolan/libplacebo/-/commit/523056828ab86c2f17ea65f432424d48b6fdd389.patch";
      sha256 = "051vhd0l3yad1fzn5zayi08kqs9an9j8p7m63kgqyfv1ksnydpcs";
    })
    (fetchpatch {
      url = "https://code.videolan.org/videolan/libplacebo/-/commit/82e3be1839379791b58e98eb049415b42888d5b0.patch";
      sha256 = "0nklj9gfiwkbbj6wfm1ck33hphaxrvzb84c4h2nfj88bapnlm90l";
    })
  ];

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
