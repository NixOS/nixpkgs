{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, vulkan-headers
, vulkan-loader
, shaderc
, glslang
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "1.29.1";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ly5bwy0pwgvqigpaak8hnig5hksjwf0pzvj3mdv3j2f6f7ya2zz";
  };

  postPatch = "substituteInPlace meson.build --replace 1.29.0 1.29.1";

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    shaderc
    glslang
    lcms2
  ];

  meta = with stdenv.lib; {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    homepage = "https://code.videolan.org/videolan/libplacebo";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
