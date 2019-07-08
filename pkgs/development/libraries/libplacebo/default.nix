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
  version = "1.18.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ib12i2491piwiz0g5n5izr5jmn5fhwzicq97vfki3r7wrdb54mz";
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
