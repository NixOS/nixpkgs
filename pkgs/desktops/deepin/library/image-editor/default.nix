{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, dtkwidget
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, opencv
, freeimage
, libmediainfo
, ffmpegthumbnailer
, pcre
}:

stdenv.mkDerivation rec {
  pname = "image-editor";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-0p/aicuBfaEyvfZomnz49IJLospWIdl23ZreDe+Bzqc=";
  };

  patches = [
    (fetchpatch {
      name = "feat_check_PREFIX_value_before_set";
      url = "https://github.com/linuxdeepin/image-editor/commit/dae86e848cf53ba0ece879d81e8d5335d61a7473.patch";
      sha256 = "sha256-lxmR+nIrMWVyhl1jpA17x2yqJ40h5vnpqKKcjd8j9RY=";
    })
    (fetchpatch {
      name = "feat_use_FULL_install_path";
      url = "https://github.com/linuxdeepin/image-editor/commit/855ae53a0444ac628aa0fe893932df6263b82e2e.patch";
      sha256 = "sha256-3Dynlwl/l/b6k6hOHjTdoDQ/VGBDfyRz9b8QY8FEsCc=";
    })
  ];

  postPatch = ''
    substituteInPlace libimageviewer/service/ffmpegvideothumbnailer.cpp \
        --replace 'libPath("libffmpegthumbnailer.so")'  'QString("${ffmpegthumbnailer.out}/lib/libffmpegthumbnailer.so")'

    substituteInPlace libimageviewer/CMakeLists.txt --replace '/usr' '$out'
    substituteInPlace libimagevisualresult/CMakeLists.txt --replace '/usr' '$out'
  '';

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
    dtkwidget
    opencv
    freeimage
    libmediainfo
    ffmpegthumbnailer
    pcre
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "Image editor lib for dtk";
    homepage = "https://github.com/linuxdeepin/image-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
