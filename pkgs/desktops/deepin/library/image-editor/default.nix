{ stdenv
, lib
, fetchFromGitHub
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
  version = "1.0.35";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-Xr4tueipQbRHyKLStTWeUcVbX7Baiz0YooaaVk65Y+U=";
  };

  postPatch = ''
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

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Image editor lib for dtk";
    homepage = "https://github.com/linuxdeepin/image-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
