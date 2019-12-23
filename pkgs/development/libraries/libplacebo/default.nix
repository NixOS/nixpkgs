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
  version = "1.29.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w0ihyc01y25ic4wsm26q5haalm4i3np5azzwyw4m011dlwxdiwr";
  };

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
