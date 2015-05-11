{ stdenv, fetchurl, doxygen, qt5 }:

stdenv.mkDerivation rec {
  name = "signon-8.56";
  src = fetchurl {
    url = "https://accounts-sso.googlecode.com/files/${name}.tar.bz2";
    sha256 = "00kwysm7bga0bycclkcyslsa6aahcn98drm125l6brzhigc7qxa8";
  };

  buildInputs = [ qt5.base ];
  nativeBuildInputs = [ doxygen ];

  configurePhase = ''
    qmake PREFIX=$out LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake/SignOnQt5
  '';

  postInstall = ''
    mv $out/lib/cmake/SignOnQt5/SignOnQtConfig.cmake \
      $out/lib/cmake/SignOnQt5/SignOnQt5Config.cmake
    mv $out/lib/cmake/SignOnQt5/SignOnQtConfigVersion.cmake \
      $out/lib/cmake/SignOnQt5/SignOnQt5ConfigVersion.cmake
  '';

}
