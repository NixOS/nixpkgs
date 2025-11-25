{
  lib,
  stdenv,
  fetchurl,
  cmake,
  taglib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "taglib-extras";
  version = "1.0.1";
  src = fetchurl {
    url = "https://download.kde.org/stable/taglib-extras/${version}/src/taglib-extras-${version}.tar.gz";
    sha256 = "0cln49ws9svvvals5fzxjxlzqm0fzjfymn7yfp4jfcjz655nnm7y";
  };

  patches = [
    (fetchurl {
      name = "2001-taglib-extras-Fix-taglib-2.x-compat.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/taglib-2.0.diff?h=taglib-extras&id=5826657b841b138c501e0633d1c9333fe9197b00";
      hash = "sha256-yhme2KcIS5SPXz+mx/R2OiLV57WHz6WW8LJtYab4h5I=";
    })
  ];

  buildInputs = [ taglib ];
  nativeBuildInputs = [
    cmake
    zlib
  ];

  cmakeFlags = [ (lib.strings.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];

  # Workaround for upstream bug https://bugs.kde.org/show_bug.cgi?id=357181
  preConfigure = ''
    sed -i -e 's/STRLESS/VERSION_LESS/g' cmake/modules/FindTaglib.cmake
  '';

  meta = with lib; {
    description = "Additional taglib plugins";
    mainProgram = "taglib-extras-config";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
