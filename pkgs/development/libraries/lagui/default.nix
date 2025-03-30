{ lib
, stdenv
, fetchFromGitea
, cmake
, freetype
, glew
, libpng
, libGL
, xorg
}:

stdenv.mkDerivation rec {
  pname = "lagui";
  version = "unstable-2023-01-26";

  src = fetchFromGitea {
    domain = "www.wellobserve.com/repositories";
    owner = "chengdulittlea";
    repo = "LaGUI";
    rev = "b8e899caf5b9f07ebf3298ca7aa29636b01cc8ec";
    hash = "sha256-yj0I3+xcKIe3kxYU2TBr174w3q4eQA9rILG3aDvmk7k=";
  };
  # On next release:
  #src = fetchzip {
  #  url = "https://www.wellobserve.com/Files/LaGUI/LaGUI_src_${version}_with_fonts.tar.gz";
  #  hash = "sha256-lDwbVzokjwjX1HpTOfHyZP4o9GQ8RTJdn3zmAeC9Vxs=";
  #};

  # Can't override the variable for some reason
  postPatch = ''
    sed -ie '/\(set\|SET\)(LAGUI_FONT_CUSTOM_PATH/d' CMakeLists.txt
    cat CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    freetype
    glew
    libGL
    libpng
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
  ];

  cmakeFlags = [ "-DLAGUI_FONT_CUSTOM_PATH=${placeholder "out"}/share/fonts/lagui" ];

  meta = with lib; {
    homepage = "https://www.wellobserve.com/?post=20221022165137";
    description = "An OpenGL based data driven graphical application framework";
    # OFL is for noto font. TODO patch in our own noto fonts and use src without fonts
    license = [ licenses.gpl3Plus licenses.ofl ];
    # https://github.com/NixOS/nixpkgs/pull/209448#issuecomment-1374716174
    platforms = intersectLists (intersectLists platforms.littleEndian platforms."64bit") platforms.linux;
    maintainers = with maintainers; [ fgaz ];
  };
}
